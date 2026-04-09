<?php
// ================================================================
//  api.php — REST-like JSON API  (v2)
//  Rhodes Intel · Arknights & Endfield Wiki
// ================================================================
error_reporting(E_ALL);
ini_set('display_errors', '0');

// ── Catch fatal PHP errors and return JSON instead of empty body ──
register_shutdown_function(function () {
    $e = error_get_last();
    if ($e && in_array($e['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        if (!headers_sent()) {
            http_response_code(500);
            header('Content-Type: application/json; charset=utf-8');
        }
        echo json_encode([
            'success' => false,
            'error'   => 'PHP fatal error: ' . $e['message'] . ' (line ' . $e['line'] . ' in ' . basename($e['file']) . ')'
        ]);
    }
});
//
//  RESOURCES
//  OPERATORS  GET/POST/PUT/DELETE  ?resource=operators[&id=N]
//               GET supports: search, game, element, class,
//                             faction, rarity, tier, limit, page
//  BANNERS    GET/POST/PUT/DELETE  ?resource=banners[&id=bN]
//               GET supports: game, type filter
//  OUTFITS    GET/POST/PUT/DELETE  ?resource=outfits[&id=N]
//               GET supports: game filter
//  NEWS       GET/POST/PUT/DELETE  ?resource=news[&id=N]
//               GET supports: type, game, hero filters
//
//  AUTH (write operations)
//  All POST / PUT / DELETE require header:  X-API-Key: your-secret
//  Change API_KEY below. GET requests are always public.
// ================================================================

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, X-API-Key');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

require_once 'db.php';

// ── API KEY — change this to your own secret ──────────────────
define('API_KEY', 'rhodes-intel-2025');

$method   = $_SERVER['REQUEST_METHOD'];
$resource = trim($_GET['resource'] ?? '');
$rawId    = $_GET['id'] ?? null;
$intId    = $rawId !== null ? (int)$rawId : 0;

// ── Auth guard for write operations ───────────────────────────
if (in_array($method, ['POST','PUT','DELETE'])) {
    // Apache strips HTTP_ prefixed headers — use getallheaders() as primary
    $headers = function_exists('getallheaders') ? array_change_key_case(getallheaders(), CASE_UPPER) : [];
    $key = $headers['X-API-KEY']
        ?? $_SERVER['HTTP_X_API_KEY']
        ?? $_SERVER['REDIRECT_HTTP_X_API_KEY']
        ?? ($_GET['key'] ?? '');
    if (trim($key) !== API_KEY) {
        respond(['success'=>false,'error'=>'Unauthorized. Provide X-API-Key header.'], 401);
    }
}

// ── Helpers ───────────────────────────────────────────────────
function respond(array $data, int $code = 200): void {
    http_response_code($code);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}
function body(): array {
    $raw = file_get_contents('php://input');
    return $raw ? (json_decode($raw, true) ?? []) : [];
}
function clean(string $v): string {
    return htmlspecialchars(strip_tags(trim($v)), ENT_QUOTES, 'UTF-8');
}

// ── Router ────────────────────────────────────────────────────
if      ($resource === 'operators') { handleOperators($method, $intId); }
elseif  ($resource === 'banners')   { handleBanners($method, $rawId);   }
elseif  ($resource === 'outfits')   { handleOutfits($method, $intId);   }
elseif  ($resource === 'news')      { handleNews($method, $intId);      }
elseif  ($resource === 'activity')  { handleActivity($method);          }
else    respond(['success'=>false,'error'=>'Unknown resource. Use: operators, banners, outfits, news, activity'], 400);
// ══════════════════════════════════════════════════════════════
//  OPERATORS
//  + GET supports ?limit=N&page=N pagination
//  + GET supports ?tier=S/A/B/C/D
//  + POST/PUT now include res, tier fields
// ══════════════════════════════════════════════════════════════
function handleOperators(string $method, int $id): void {
    $db = getDB();

    if ($method === 'GET') {
        if ($id) {
            $s = $db->prepare('SELECT * FROM operators WHERE id = ?');
            $s->execute([$id]);
            $row = $s->fetch();
            if (!$row) respond(['success'=>false,'error'=>"Operator #$id not found."], 404);
            respond(['success'=>true,'data'=>$row]);
        }

        $conds=[]; $params=[];

        if (!empty($_GET['search'])) {
            $conds[]='(name LIKE ? OR real_name LIKE ? OR faction LIKE ? OR title LIKE ? OR class LIKE ? OR biography LIKE ?)';
            $like='%'.trim($_GET['search']).'%';
            $params=array_merge($params,[$like,$like,$like,$like,$like,$like]);
        }

        foreach (['game','element','class','faction','tier'] as $col) {
            if (!empty($_GET[$col])) { $conds[]="$col=?"; $params[]=$_GET[$col]; }
        }
        if (!empty($_GET['rarity'])) { $conds[]='rarity=?'; $params[]=(int)$_GET['rarity']; }

        $sql = 'SELECT * FROM operators'
             . ($conds ? ' WHERE '.implode(' AND ',$conds) : '')
             . ' ORDER BY rarity DESC, name ASC';

        // Pagination
        $limit = isset($_GET['limit']) ? max(1,min(200,(int)$_GET['limit'])) : null;
        $page  = isset($_GET['page'])  ? max(1,(int)$_GET['page']) : 1;

        if ($limit) {
            $offset = ($page - 1) * $limit;
            // Total count without limit
            $cnt = $db->prepare('SELECT COUNT(*) FROM operators'.($conds?' WHERE '.implode(' AND ',$conds):''));
            $cnt->execute($params);
            $total = (int)$cnt->fetchColumn();
            $sql  .= " LIMIT $limit OFFSET $offset";
            $s = $db->prepare($sql); $s->execute($params);
            respond(['success'=>true,'total'=>$total,'page'=>$page,'limit'=>$limit,
                     'pages'=>(int)ceil($total/$limit),'data'=>$s->fetchAll()]);
        }

        $s = $db->prepare($sql); $s->execute($params);
        $rows = $s->fetchAll();
        respond(['success'=>true,'total'=>count($rows),'data'=>$rows]);
    }

    if ($method === 'POST') {
        $b = body();
        if (empty($b['name'])) respond(['success'=>false,'error'=>'Name is required.'], 422);
        $tier = in_array($b['tier']??'', ['S','A','B','C','D']) ? $b['tier'] : null;
        $s = $db->prepare(
            'INSERT INTO operators
             (game,name,real_name,title,rarity,element,class,faction,species,gender,
              height,birthday,release_date,hp,atk,def,res,tier,is_featured,is_meta,
              emoji,biography,image_url,pfp_url,gif_url)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'
        );
        $s->execute([
            $b['game']??'arknights', clean($b['name']),
            clean($b['real_name']??'Unknown'), clean($b['title']??''),
            (int)($b['rarity']??5), $b['element']??'Physical',
            clean($b['class']??'Guard'), clean($b['faction']??'Rhodes Island'),
            clean($b['species']??'Human'), $b['gender']??'Unknown',
            clean($b['height']??'Unknown'), clean($b['birthday']??'Unknown'),
            clean($b['release_date']??'TBA'),
            (int)($b['hp']??10000),(int)($b['atk']??800),(int)($b['def']??600),
            (int)($b['res']??0), $tier,
            (int)($b['is_featured']??0),(int)($b['is_meta']??0),
            $b['emoji']??'⚡', $b['biography']??null,
            $b['image_url']??'',$b['pfp_url']??'',$b['gif_url']??''
        ]);
        $newId = (int)$db->lastInsertId();
        $s2 = $db->prepare('SELECT * FROM operators WHERE id=?'); $s2->execute([$newId]);
        respond(['success'=>true,'message'=>'Operator created.','data'=>$s2->fetch()], 201);
    }

    if ($method === 'PUT') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to update.'], 400);
        $b = body();
        $tier = in_array($b['tier']??'', ['S','A','B','C','D']) ? $b['tier'] : null;
        $s = $db->prepare(
            'UPDATE operators SET
             game=?,name=?,real_name=?,title=?,rarity=?,element=?,class=?,faction=?,
             species=?,gender=?,height=?,birthday=?,release_date=?,
             hp=?,atk=?,def=?,res=?,tier=?,is_featured=?,is_meta=?,
             emoji=?,biography=?,image_url=?,pfp_url=?,gif_url=?
             WHERE id=?'
        );
        $s->execute([
            $b['game']??'arknights', clean($b['name']??''),
            clean($b['real_name']??'Unknown'), clean($b['title']??''),
            (int)($b['rarity']??5), $b['element']??'Physical',
            clean($b['class']??'Guard'), clean($b['faction']??'Rhodes Island'),
            clean($b['species']??'Human'), $b['gender']??'Unknown',
            clean($b['height']??'Unknown'), clean($b['birthday']??'Unknown'),
            clean($b['release_date']??'TBA'),
            (int)($b['hp']??10000),(int)($b['atk']??800),(int)($b['def']??600),
            (int)($b['res']??0), $tier,
            (int)($b['is_featured']??0),(int)($b['is_meta']??0),
            $b['emoji']??'⚡', $b['biography']??null,
            $b['image_url']??'',$b['pfp_url']??'',$b['gif_url']??'',
            $id
        ]);
        $s2 = $db->prepare('SELECT * FROM operators WHERE id=?'); $s2->execute([$id]);
        $row = $s2->fetch();
        if (!$row) respond(['success'=>false,'error'=>"Operator #$id not found."], 404);
        respond(['success'=>true,'message'=>'Operator updated.','data'=>$row]);
    }

    if ($method === 'DELETE') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to delete.'], 400);
        $chk = $db->prepare('SELECT id,name FROM operators WHERE id=?'); $chk->execute([$id]);
        $row = $chk->fetch();
        if (!$row) respond(['success'=>false,'error'=>"Operator #$id not found."], 404);
        $db->prepare('DELETE FROM operators WHERE id=?')->execute([$id]);
        respond(['success'=>true,'message'=>"'{$row['name']}' deleted."]);
    }

    respond(['success'=>false,'error'=>"Method $method not allowed."], 405);
}

// ══════════════════════════════════════════════════════════════
//  BANNERS
//  + GET supports ?game=Arknights|Endfield filter
//  + POST/PUT now include start_date, end_date fields
//  DB column: drop_info  →  JS field: drop
// ══════════════════════════════════════════════════════════════
function mapBanner(array $r): array {
    return [
        'id'         => $r['id'],
        'type'       => $r['type'],
        'name'       => $r['name'],
        'op'         => $r['op'],
        'rarity'     => (int)$r['rarity'],
        'game'       => $r['game'],
        'date'       => $r['date'],
        'start_date' => $r['start_date'] ?? null,
        'end_date'   => $r['end_date']   ?? null,
        'image'      => $r['image']    ?? '',
        'drop'       => $r['drop_info'] ?? '',
        'about'      => $r['about']    ?? '',
    ];
}

function handleBanners(string $method, ?string $id): void {
    $db = getDB();

    if ($method === 'GET') {
        if ($id) {
            $s = $db->prepare('SELECT * FROM banners WHERE id=?'); $s->execute([$id]);
            $row = $s->fetch();
            if (!$row) respond(['success'=>false,'error'=>"Banner '$id' not found."], 404);
            respond(['success'=>true,'data'=>mapBanner($row)]);
        }

        $conds=[]; $params=[];
        if (!empty($_GET['game']))  { $conds[]='game=?';  $params[]=$_GET['game']; }
        if (!empty($_GET['type']))  { $conds[]='type=?';  $params[]=$_GET['type']; }

        $where = $conds ? ' WHERE '.implode(' AND ',$conds) : '';
        $s = $db->prepare("SELECT * FROM banners$where ORDER BY FIELD(type,'feat','std'),name ASC");
        $s->execute($params);
        respond(['success'=>true,'data'=>array_map('mapBanner',$s->fetchAll())]);
    }

    if ($method === 'POST') {
        $b = body();
        if (empty($b['name'])) respond(['success'=>false,'error'=>'Name is required.'], 422);
        // Generate a clean sequential ID: find max numeric suffix in banners table
        $maxRow = $db->query("SELECT id FROM banners")->fetchAll(PDO::FETCH_COLUMN);
        $maxNum = 0;
        foreach ($maxRow as $bid) {
            $n = (int) preg_replace('/\D/', '', $bid);
            if ($n > $maxNum) $maxNum = $n;
        }
        $newId = 'b' . ($maxNum + 1);
        $s = $db->prepare(
            'INSERT INTO banners (id,type,name,op,rarity,game,date,start_date,end_date,image,drop_info,about)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?)'
        );
        try {
            $s->execute([
                $newId,
                in_array($b['type']??'',['feat','std'])?$b['type']:'feat',
                clean($b['name']), clean($b['op']??'TBA'),
                (int)($b['rarity']??6), clean($b['game']??'Arknights'),
                clean($b['date']??'TBA'),
                !empty($b['start_date']) ? $b['start_date'] : null,
                !empty($b['end_date'])   ? $b['end_date']   : null,
                $b['image']??'', $b['drop']??'', $b['about']??''
            ]);
        } catch (PDOException $e) {
            // 23000 = integrity constraint (duplicate key)
            if ($e->getCode() === '23000') {
                respond(['success'=>false,'error'=>'Duplicate banner ID — please try again.'], 409);
            }
            throw $e;
        }
        $s2 = $db->prepare('SELECT * FROM banners WHERE id=?'); $s2->execute([$newId]);
        respond(['success'=>true,'message'=>'Banner created.','data'=>mapBanner($s2->fetch())], 201);
    }

    if ($method === 'PUT') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to update.'], 400);
        $b = body();
        $chk = $db->prepare('SELECT id FROM banners WHERE id=?'); $chk->execute([$id]);
        if (!$chk->fetch()) respond(['success'=>false,'error'=>"Banner '$id' not found."], 404);
        $s = $db->prepare(
            'UPDATE banners SET type=?,name=?,op=?,rarity=?,game=?,date=?,
             start_date=?,end_date=?,image=?,drop_info=?,about=? WHERE id=?'
        );
        $s->execute([
            in_array($b['type']??'',['feat','std'])?$b['type']:'feat',
            clean($b['name']??''), clean($b['op']??'TBA'),
            (int)($b['rarity']??6), clean($b['game']??'Arknights'),
            clean($b['date']??'TBA'),
            !empty($b['start_date']) ? $b['start_date'] : null,
            !empty($b['end_date'])   ? $b['end_date']   : null,
            $b['image']??'', $b['drop']??'', $b['about']??'', $id
        ]);
        $s2 = $db->prepare('SELECT * FROM banners WHERE id=?'); $s2->execute([$id]);
        respond(['success'=>true,'message'=>'Banner updated.','data'=>mapBanner($s2->fetch())]);
    }

    if ($method === 'DELETE') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to delete.'], 400);
        $chk = $db->prepare('SELECT id,name FROM banners WHERE id=?'); $chk->execute([$id]);
        $row = $chk->fetch();
        if (!$row) respond(['success'=>false,'error'=>"Banner '$id' not found."], 404);
        $db->prepare('DELETE FROM banners WHERE id=?')->execute([$id]);
        respond(['success'=>true,'message'=>"'{$row['name']}' deleted."]);
    }

    respond(['success'=>false,'error'=>"Method $method not allowed."], 405);
}

// ══════════════════════════════════════════════════════════════
//  OUTFITS
//  + GET supports ?game=arknights|endfield filter
//  + POST/PUT now include game field
//  DB column: description → JS field: desc
// ══════════════════════════════════════════════════════════════
function mapOutfit(array $r): array {
    return [
        'id'     => (int)$r['id'],
        'name'   => $r['name'],
        'op'     => $r['op'],
        'game'   => $r['game'],
        'rarity' => $r['rarity'],
        'price'  => $r['price'],
        'image'  => $r['image']       ?? '',
        'emoji'  => $r['emoji']       ?? '🎀',
        'desc'   => $r['description'] ?? '',
        'obtain' => $r['obtain']      ?? '',
    ];
}

function handleOutfits(string $method, int $id): void {
    $db = getDB();

    if ($method === 'GET') {
        if ($id) {
            $s = $db->prepare('SELECT * FROM outfits WHERE id=?'); $s->execute([$id]);
            $row = $s->fetch();
            if (!$row) respond(['success'=>false,'error'=>"Outfit #$id not found."], 404);
            respond(['success'=>true,'data'=>mapOutfit($row)]);
        }
        $conds=[]; $params=[];
        if (!empty($_GET['game'])) { $conds[]='game=?'; $params[]=$_GET['game']; }
        $where = $conds ? ' WHERE '.implode(' AND ',$conds) : '';
        $s = $db->prepare("SELECT * FROM outfits$where ORDER BY id ASC");
        $s->execute($params);
        respond(['success'=>true,'data'=>array_map('mapOutfit',$s->fetchAll())]);
    }

    if ($method === 'POST') {
        $b = body();
        if (empty($b['name'])) respond(['success'=>false,'error'=>'Name is required.'], 422);
        $s = $db->prepare(
            'INSERT INTO outfits (name,op,game,rarity,price,image,emoji,description,obtain)
             VALUES (?,?,?,?,?,?,?,?,?)'
        );
        $s->execute([
            clean($b['name']), clean($b['op']??'Unknown'),
            clean($b['game']??'arknights'),
            $b['rarity']??'★★★★★', clean($b['price']??'N/A'),
            $b['image']??'', $b['emoji']??'🎀',
            $b['desc']??'', clean($b['obtain']??'')
        ]);
        $newId = (int)$db->lastInsertId();
        $s2 = $db->prepare('SELECT * FROM outfits WHERE id=?'); $s2->execute([$newId]);
        respond(['success'=>true,'message'=>'Outfit created.','data'=>mapOutfit($s2->fetch())], 201);
    }

    if ($method === 'PUT') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to update.'], 400);
        $b = body();
        $chk = $db->prepare('SELECT id FROM outfits WHERE id=?'); $chk->execute([$id]);
        if (!$chk->fetch()) respond(['success'=>false,'error'=>"Outfit #$id not found."], 404);
        $s = $db->prepare(
            'UPDATE outfits SET name=?,op=?,game=?,rarity=?,price=?,image=?,emoji=?,
             description=?,obtain=? WHERE id=?'
        );
        $s->execute([
            clean($b['name']??''), clean($b['op']??'Unknown'),
            clean($b['game']??'arknights'),
            $b['rarity']??'★★★★★', clean($b['price']??'N/A'),
            $b['image']??'', $b['emoji']??'🎀',
            $b['desc']??'', clean($b['obtain']??''), $id
        ]);
        $s2 = $db->prepare('SELECT * FROM outfits WHERE id=?'); $s2->execute([$id]);
        respond(['success'=>true,'message'=>'Outfit updated.','data'=>mapOutfit($s2->fetch())]);
    }

    if ($method === 'DELETE') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to delete.'], 400);
        $chk = $db->prepare('SELECT id,name FROM outfits WHERE id=?'); $chk->execute([$id]);
        $row = $chk->fetch();
        if (!$row) respond(['success'=>false,'error'=>"Outfit #$id not found."], 404);
        $db->prepare('DELETE FROM outfits WHERE id=?')->execute([$id]);
        respond(['success'=>true,'message'=>"'{$row['name']}' deleted."]);
    }

    respond(['success'=>false,'error'=>"Method $method not allowed."], 405);
}

// ══════════════════════════════════════════════════════════════
//  NEWS  (new resource)
//  GET supports ?type=event|update|... and ?game=arknights|...
//               and ?hero=1 to get only is_hero items
// ══════════════════════════════════════════════════════════════
function handleNews(string $method, int $id): void {
    $db = getDB();

    if ($method === 'GET') {
        if ($id) {
            $s = $db->prepare('SELECT * FROM news WHERE id=?'); $s->execute([$id]);
            $row = $s->fetch();
            if (!$row) respond(['success'=>false,'error'=>"News #$id not found."], 404);
            respond(['success'=>true,'data'=>$row]);
        }
        $conds=[]; $params=[];
        $validTypes = ['event','update','maintenance','collab','announcement'];
        if (!empty($_GET['type']) && in_array($_GET['type'],$validTypes)) {
            $conds[]='type=?'; $params[]=$_GET['type'];
        }
        if (!empty($_GET['game'])) { $conds[]='(game=? OR game=\'both\')'; $params[]=$_GET['game']; }
        if (!empty($_GET['hero'])) { $conds[]='is_hero=1'; }
        $where = $conds ? ' WHERE '.implode(' AND ',$conds) : '';
        $s = $db->prepare("SELECT * FROM news$where ORDER BY id DESC");
        $s->execute($params);
        respond(['success'=>true,'data'=>$s->fetchAll()]);
    }

    if ($method === 'POST') {
        $b = body();
        if (empty($b['title'])) respond(['success'=>false,'error'=>'Title is required.'], 422);
        $validTypes = ['event','update','maintenance','collab','announcement'];
        $type = in_array($b['type']??'',$validTypes) ? $b['type'] : 'event';
        $validGames = ['arknights','endfield','both'];
        $game = in_array($b['game']??'',$validGames) ? $b['game'] : 'arknights';
        $s = $db->prepare(
            'INSERT INTO news (type,game,title,snip,full,image,icon,date,is_hero)
             VALUES (?,?,?,?,?,?,?,?,?)'
        );
        $s->execute([
            $type, $game,
            clean($b['title']),
            $b['snip'] ?? null,
            $b['full']  ?? null,
            $b['image'] ?? '',
            $b['icon']  ?? '📰',
            clean($b['date'] ?? 'TBA'),
            (int)($b['is_hero'] ?? 0),
        ]);
        $newId = (int)$db->lastInsertId();
        $s2 = $db->prepare('SELECT * FROM news WHERE id=?'); $s2->execute([$newId]);
        respond(['success'=>true,'message'=>'News item created.','data'=>$s2->fetch()], 201);
    }

    if ($method === 'PUT') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to update.'], 400);
        $b = body();
        $chk = $db->prepare('SELECT id FROM news WHERE id=?'); $chk->execute([$id]);
        if (!$chk->fetch()) respond(['success'=>false,'error'=>"News #$id not found."], 404);
        $validTypes = ['event','update','maintenance','collab','announcement'];
        $type = in_array($b['type']??'',$validTypes) ? $b['type'] : 'event';
        $validGames = ['arknights','endfield','both'];
        $game = in_array($b['game']??'',$validGames) ? $b['game'] : 'arknights';
        $s = $db->prepare(
            'UPDATE news SET type=?,game=?,title=?,snip=?,full=?,image=?,icon=?,date=?,is_hero=?
             WHERE id=?'
        );
        $s->execute([
            $type, $game,
            clean($b['title'] ?? ''),
            $b['snip'] ?? null,
            $b['full']  ?? null,
            $b['image'] ?? '',
            $b['icon']  ?? '📰',
            clean($b['date'] ?? 'TBA'),
            (int)($b['is_hero'] ?? 0),
            $id
        ]);
        $s2 = $db->prepare('SELECT * FROM news WHERE id=?'); $s2->execute([$id]);
        respond(['success'=>true,'message'=>'News updated.','data'=>$s2->fetch()]);
    }

    if ($method === 'DELETE') {
        if (!$id) respond(['success'=>false,'error'=>'Provide ?id= to delete.'], 400);
        $chk = $db->prepare('SELECT id,title FROM news WHERE id=?'); $chk->execute([$id]);
        $row = $chk->fetch();
        if (!$row) respond(['success'=>false,'error'=>"News #$id not found."], 404);
        $db->prepare('DELETE FROM news WHERE id=?')->execute([$id]);
        respond(['success'=>true,'message'=>"'{$row['title']}' deleted."]);
    }

    respond(['success'=>false,'error'=>"Method $method not allowed."], 405);
}

// ══════════════════════════════════════════════════════════════
//  ACTIVITY LOG  —  POST logs pull/add events from JS
//  Auto-creates users + activity_log tables if missing
//  GET  ?resource=activity            → returns last 200 events (admin)
//  POST ?resource=activity            → logs one event
// ══════════════════════════════════════════════════════════════
function handleActivity(string $method): void {
    $db = getDB();

    // Ensure tables exist (with password column)
    $db->exec("CREATE TABLE IF NOT EXISTS `users` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `username`   VARCHAR(80)  NOT NULL UNIQUE,
        `password`   VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'Plain text for demo project',
        `role`       VARCHAR(20)  NOT NULL DEFAULT 'user',
        `pull_count` INT NOT NULL DEFAULT 0,
        `last_login` TIMESTAMP NULL,
        `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    // Add password column if it doesn't exist yet (safe migration)
    try {
        $db->exec("ALTER TABLE `users` ADD COLUMN `password` VARCHAR(255) NOT NULL DEFAULT '' COMMENT 'Plain text for demo project' AFTER `username`");
    } catch (\Throwable $e) { /* column already exists — ignore */ }

    $db->exec("CREATE TABLE IF NOT EXISTS `activity_log` (
        `id`         INT AUTO_INCREMENT PRIMARY KEY,
        `username`   VARCHAR(80)  NOT NULL,
        `role`       VARCHAR(20)  NOT NULL DEFAULT 'user',
        `action`     VARCHAR(50)  NOT NULL,
        `detail`     TEXT         DEFAULT NULL,
        `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    if ($method === 'GET') {
        $s = $db->query("SELECT * FROM activity_log ORDER BY created_at DESC LIMIT 200");
        respond(['success'=>true, 'data'=>$s->fetchAll()]);
    }

    if ($method === 'POST') {
        $b = body();
        $username = trim($b['username'] ?? 'unknown');
        $password = trim($b['password'] ?? '');
        $role     = trim($b['role']     ?? 'user');
        $action   = strtoupper(trim($b['action'] ?? 'EVENT'));
        $detail   = trim($b['detail']  ?? '');

        // Upsert user row — store username, password, role, last_login
        $db->prepare(
            "INSERT INTO users (username, password, role, pull_count, last_login)
             VALUES (?, ?, ?, 0, NOW())
             ON DUPLICATE KEY UPDATE
               password   = IF(VALUES(password) != '', VALUES(password), password),
               role       = VALUES(role),
               last_login = NOW()"
        )->execute([$username, $password, $role]);

        // If pull action, increment pull_count
        if (strpos($action, 'PULL') !== false) {
            preg_match('/(\d+)/', $detail, $m);
            $cnt = isset($m[1]) ? (int)$m[1] : 1;
            $db->prepare("UPDATE users SET pull_count = pull_count + ? WHERE username = ?")
               ->execute([$cnt, $username]);
        }

        // Insert activity log row
        $db->prepare("INSERT INTO activity_log (username, role, action, detail) VALUES (?,?,?,?)")
           ->execute([$username, $role, $action, $detail ?: null]);

        respond(['success'=>true, 'message'=>'Logged.']);
    }

    respond(['success'=>false,'error'=>"Method $method not allowed."], 405);
}

extends Control

# Minigame: Kolorowy Chaos (FFA, 2-4 players hotseat).
# A target color is announced — stand on a matching cell before the
# timer runs out. Standing on a wrong color eliminates you.

const CHAOS_COLORS: Array[Color] = [
    Color(0.85, 0.3, 0.3),
    Color(0.3, 0.5, 0.9),
    Color(0.32, 0.75, 0.35),
    Color(0.93, 0.8, 0.25),
]
const COLOR_NAMES: Array[String] = ["CZERWONY", "NIEBIESKI", "ZIELONY", "ZOLTY"]
const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 150, 1000, 480)
const COLS := 10
const ROWS := 6
const PLAYER_SIZE := Vector2(26, 26)
const SPEED := 320.0
const MAX_ROUNDS := 8
const SPAWN_OFFSETS: Array[Vector2] = [
    Vector2(-220, -80), Vector2(220, -80), Vector2(-220, 80), Vector2(220, 80),
]

var cells: Array = []
var cell_colors: Array = []
var player_nodes := {}
var alive := {}
var elimination_order: Array = []
var round_num := 0
var target := 0
var timer := 0.0
var phase := "idle"

var info_label: Label
var timer_label: Label


func _ready() -> void:
    var background := ColorRect.new()
    background.color = Color(0.09, 0.09, 0.13)
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var title := Label.new()
    title.text = "Kolorowy Chaos"
    title.add_theme_font_size_override("font_size", 28)
    title.position = Vector2(140, 20)
    add_child(title)

    info_label = Label.new()
    info_label.add_theme_font_size_override("font_size", 30)
    info_label.position = Vector2(140, 70)
    info_label.size = Vector2(800, 40)
    add_child(info_label)

    timer_label = Label.new()
    timer_label.add_theme_font_size_override("font_size", 40)
    timer_label.position = Vector2(1060, 55)
    add_child(timer_label)

    _build_cells()
    _spawn_players()
    _start_round()


func _build_cells() -> void:
    var cell_size := Vector2(ARENA.size.x / COLS, ARENA.size.y / ROWS)
    for row in ROWS:
        for col in COLS:
            var cell := ColorRect.new()
            cell.position = ARENA.position + Vector2(col * cell_size.x, row * cell_size.y) + Vector2(2, 2)
            cell.size = cell_size - Vector2(4, 4)
            add_child(cell)
            cells.append(cell)
            cell_colors.append(0)


func _spawn_players() -> void:
    for player in PlayerManager.players:
        var pid: int = player["id"]
        var outline := ColorRect.new()
        outline.color = Color(0.05, 0.05, 0.05)
        outline.size = PLAYER_SIZE
        outline.position = ARENA.get_center() + SPAWN_OFFSETS[pid] - PLAYER_SIZE / 2.0
        var fill := ColorRect.new()
        fill.color = player["color"]
        fill.size = PLAYER_SIZE - Vector2(6, 6)
        fill.position = Vector2(3, 3)
        outline.add_child(fill)
        add_child(outline)
        player_nodes[pid] = outline
        alive[pid] = true


func _start_round() -> void:
    round_num += 1
    for i in cells.size():
        cell_colors[i] = randi() % CHAOS_COLORS.size()
        cells[i].color = CHAOS_COLORS[cell_colors[i]]
    target = randi() % CHAOS_COLORS.size()
    info_label.text = "Runda %d — stan na: %s" % [round_num, COLOR_NAMES[target]]
    info_label.add_theme_color_override("font_color", CHAOS_COLORS[target])
    timer = clampf(3.4 - 0.25 * round_num, 1.2, 3.4)
    phase = "move"


func _process(delta: float) -> void:
    if phase != "move":
        return
    for pid in player_nodes:
        if not alive[pid]:
            continue
        var keys: Array = KEY_SETS[pid]
        var direction := Vector2.ZERO
        if Input.is_physical_key_pressed(keys[0]):
            direction.y -= 1
        if Input.is_physical_key_pressed(keys[1]):
            direction.y += 1
        if Input.is_physical_key_pressed(keys[2]):
            direction.x -= 1
        if Input.is_physical_key_pressed(keys[3]):
            direction.x += 1
        if direction != Vector2.ZERO:
            var node: ColorRect = player_nodes[pid]
            node.position += direction.normalized() * SPEED * delta
            node.position = node.position.clamp(
                ARENA.position,
                ARENA.position + ARENA.size - PLAYER_SIZE
            )
    timer -= delta
    timer_label.text = "%.1f" % maxf(timer, 0.0)
    if timer <= 0.0:
        _judge()


func _judge() -> void:
    phase = "pause"
    for pid in player_nodes:
        if not alive[pid]:
            continue
        var center: Vector2 = player_nodes[pid].position + PLAYER_SIZE / 2.0
        var col := clampi(int((center.x - ARENA.position.x) / (ARENA.size.x / COLS)), 0, COLS - 1)
        var row := clampi(int((center.y - ARENA.position.y) / (ARENA.size.y / ROWS)), 0, ROWS - 1)
        if cell_colors[row * COLS + col] != target:
            alive[pid] = false
            elimination_order.append(pid)
            player_nodes[pid].modulate.a = 0.25
    for i in cells.size():
        if cell_colors[i] != target:
            cells[i].color = cells[i].color.darkened(0.65)
    var alive_count := 0
    for pid in alive:
        if alive[pid]:
            alive_count += 1
    if alive_count <= 1 or round_num >= MAX_ROUNDS:
        _finish()
    else:
        await get_tree().create_timer(1.0).timeout
        _start_round()


func _finish() -> void:
    phase = "done"
    var ranking: Array = []
    for pid in alive:
        if alive[pid]:
            ranking.append(pid)
    var eliminated := elimination_order.duplicate()
    eliminated.reverse()
    ranking.append_array(eliminated)
    var winner_text := "Remis!"
    if not ranking.is_empty():
        winner_text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]
    info_label.text = winner_text
    info_label.add_theme_color_override("font_color", Color.WHITE)
    await get_tree().create_timer(1.2).timeout
    MinigameManager.report_finished(ranking)

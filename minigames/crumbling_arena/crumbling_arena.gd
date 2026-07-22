extends Control

# Minigame: Kruszaca Arena (FFA, 2-4 hotseat).
# Floor tiles crack and fall away. Don't stand on a hole. Last bear wins.

const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const COLS := 10
const ROWS := 6
const SPEED := 300.0
const CRACK_TIME := 0.9
const TIME_LIMIT := 60.0
const SPAWN_OFFSETS: Array[Vector2] = [
    Vector2(-220, -80), Vector2(220, -80), Vector2(-220, 80), Vector2(220, 80),
]

enum Cell { SOLID, CRACKING, GONE }

var cells: Array = []
var cell_states: Array = []
var crack_timers: Array = []
var player_nodes := {}
var alive := {}
var elimination_order: Array = []
var interval := 1.6
var spawn_timer := 1.2
var time_left := TIME_LIMIT
var phase := "play"

var banner_label: Label


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var pit := Panel.new()
    pit.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.09, 0.07, 0.1), 24, 6, Color(0.28, 0.2, 0.14), 10)
    )
    pit.position = ARENA.position - Vector2(16, 16)
    pit.size = ARENA.size + Vector2(32, 32)
    add_child(pit)

    var banner := Panel.new()
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.5, 0.32, 0.18), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 74)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 26, Color.WHITE)
    banner_label.text = "Podloga sie kruszy — nie stoj na dziurach!"
    banner.add_child(banner_label)

    var title := Label.new()
    title.text = "Kruszaca Arena"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.75))
    title.position = Vector2(60, 44)
    add_child(title)

    var cell_size := Vector2(ARENA.size.x / COLS, ARENA.size.y / ROWS)
    for row in ROWS:
        for col in COLS:
            var cell := Panel.new()
            cell.position = ARENA.position + Vector2(col * cell_size.x, row * cell_size.y) + Vector2(3, 3)
            cell.size = cell_size - Vector2(6, 6)
            cell.pivot_offset = cell.size / 2.0
            add_child(cell)
            cells.append(cell)
            cell_states.append(Cell.SOLID)
            crack_timers.append(0.0)
            _paint(cells.size() - 1)

    for player in PlayerManager.players:
        var pid: int = player["id"]
        var bear := BearCharacter.new()
        bear.base_color = player["color"]
        bear.accessory = player["accessory"]
        bear.scale = Vector2(0.9, 0.9)
        bear.position = ARENA.get_center() + SPAWN_OFFSETS[pid]
        add_child(bear)
        player_nodes[pid] = bear
        alive[pid] = true


func _paint(index: int) -> void:
    var style: StyleBoxFlat
    match cell_states[index]:
        Cell.SOLID:
            var base := Color(0.62, 0.58, 0.52) if (index + index / COLS) % 2 == 0 else Color(0.55, 0.51, 0.46)
            style = UiStyle.flat(base, 8, 2, base.lightened(0.15))
        Cell.CRACKING:
            style = UiStyle.flat(Color(0.85, 0.5, 0.2), 8, 2, Color(1, 0.75, 0.3))
        Cell.GONE:
            style = UiStyle.flat(Color(0.07, 0.05, 0.08), 8)
    cells[index].add_theme_stylebox_override("panel", style)


func _process(delta: float) -> void:
    if phase != "play":
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
        var node: BearCharacter = player_nodes[pid]
        if direction != Vector2.ZERO:
            node.position += direction.normalized() * SPEED * delta
            node.position = node.position.clamp(
                ARENA.position + Vector2(16, 48),
                ARENA.position + ARENA.size - Vector2(16, 4)
            )
            node.rotation = sin(Time.get_ticks_msec() / 1000.0 * 15.0 + pid) * 0.09
        else:
            node.rotation = lerpf(node.rotation, 0.0, 12.0 * delta)

    spawn_timer -= delta
    if spawn_timer <= 0.0:
        interval = maxf(0.55, interval - 0.06)
        spawn_timer = interval
        _crack_random_cells(1 if interval > 1.0 else 2)

    for i in cells.size():
        if cell_states[i] == Cell.CRACKING:
            crack_timers[i] -= delta
            cells[i].rotation = sin(Time.get_ticks_msec() / 1000.0 * 40.0 + i) * 0.04
            if crack_timers[i] <= 0.0:
                cell_states[i] = Cell.GONE
                cells[i].rotation = 0.0
                _paint(i)

    for pid in player_nodes:
        if not alive[pid]:
            continue
        var feet: Vector2 = player_nodes[pid].position
        var col := clampi(int((feet.x - ARENA.position.x) / (ARENA.size.x / COLS)), 0, COLS - 1)
        var row := clampi(int((feet.y - ARENA.position.y) / (ARENA.size.y / ROWS)), 0, ROWS - 1)
        if cell_states[row * COLS + col] == Cell.GONE:
            _eliminate(pid)

    time_left -= delta
    var alive_count := 0
    for pid in alive:
        if alive[pid]:
            alive_count += 1
    if alive_count <= 1 or time_left <= 0.0:
        _finish()


func _crack_random_cells(count: int) -> void:
    var solid: Array = []
    for i in cells.size():
        if cell_states[i] == Cell.SOLID:
            solid.append(i)
    solid.shuffle()
    for i in mini(count, solid.size()):
        cell_states[solid[i]] = Cell.CRACKING
        crack_timers[solid[i]] = CRACK_TIME
        _paint(solid[i])


func _eliminate(pid: int) -> void:
    alive[pid] = false
    elimination_order.append(pid)
    var pawn: BearCharacter = player_nodes[pid]
    pawn.show_emote("shock")
    var fall := create_tween()
    fall.set_parallel()
    fall.tween_property(pawn, "modulate:a", 0.0, 0.6)
    fall.tween_property(pawn, "scale", Vector2(0.2, 0.2), 0.6)
    fall.tween_property(pawn, "rotation", PI, 0.6)
    banner_label.text = "%s wpada w dziure!" % PlayerManager.get_player(pid)["name"]


func _finish() -> void:
    phase = "done"
    var ranking: Array = []
    for pid in alive:
        if alive[pid]:
            ranking.append(pid)
    var eliminated := elimination_order.duplicate()
    eliminated.reverse()
    ranking.append_array(eliminated)
    if not ranking.is_empty():
        banner_label.text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]
    await get_tree().create_timer(1.4).timeout
    MinigameManager.report_finished(ranking)

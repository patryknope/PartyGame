extends Control

# Minigame: Kolorowy Chaos (FFA, 2-4 players hotseat).
# A target color is announced — stand on a matching cell before the
# timer runs out. Standing on a wrong color eliminates you.

const CHAOS_COLORS: Array[Color] = [
    Color(0.86, 0.3, 0.32),
    Color(0.27, 0.52, 0.9),
    Color(0.3, 0.75, 0.36),
    Color(0.95, 0.78, 0.25),
]
const COLOR_NAMES: Array[String] = ["CZERWONY", "NIEBIESKI", "ZIELONY", "ZOLTY"]
const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const COLS := 10
const ROWS := 6
const PLAYER_SIZE := Vector2(30, 30)
const SPEED := 320.0
const MAX_ROUNDS := 8
const MIN_LIVING_TILES := 8
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
var round_time := 3.4
var phase := "idle"

var banner: Panel
var banner_label: Label
var timer_bar: Panel
var round_label: Label

var _net := false
var _my_pid := -1


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var frame := Panel.new()
    frame.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.15, 0.36, 0.2), 24, 6, Color(0.11, 0.28, 0.15), 10)
    )
    frame.position = ARENA.position - Vector2(16, 16)
    frame.size = ARENA.size + Vector2(32, 32)
    add_child(frame)

    banner = Panel.new()
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 74)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 30, Color.WHITE)
    banner.add_child(banner_label)

    timer_bar = Panel.new()
    timer_bar.add_theme_stylebox_override("panel", UiStyle.flat(UiStyle.GOLD, 4))
    timer_bar.position = Vector2(340, 104)
    timer_bar.size = Vector2(600, 10)
    add_child(timer_bar)

    round_label = Label.new()
    round_label.position = Vector2(60, 40)
    UiStyle.title_look(round_label, 24, UiStyle.CREAM)
    add_child(round_label)

    var title := Label.new()
    title.text = "Kolorowy Chaos"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.7))
    title.position = Vector2(1010, 44)
    add_child(title)

    _build_cells()
    _spawn_players()
    _net = NetworkManager.is_online
    _my_pid = NetworkManager.my_player_id
    if _net:
        NetworkManager.minigame_positions.connect(_on_net_positions)
        NetworkManager.minigame_event.connect(_on_net_event)
    if not _net or NetworkManager.is_server():
        _start_round()
    else:
        phase = "wait"


func _build_cells() -> void:
    var cell_size := Vector2(ARENA.size.x / COLS, ARENA.size.y / ROWS)
    for row in ROWS:
        for col in COLS:
            var cell := Panel.new()
            cell.position = ARENA.position + Vector2(col * cell_size.x, row * cell_size.y) + Vector2(3, 3)
            cell.size = cell_size - Vector2(6, 6)
            add_child(cell)
            cells.append(cell)
            cell_colors.append(0)


func _spawn_players() -> void:
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


func _paint_cell(index: int, dimmed: bool) -> void:
    var color := CHAOS_COLORS[cell_colors[index]]
    if dimmed:
        color = color.darkened(0.72)
    cells[index].add_theme_stylebox_override(
        "panel", UiStyle.flat(color, 10, 2, color.lightened(0.25) if not dimmed else color)
    )


func _drop_random_tiles(count: int) -> void:
    var living: Array = []
    for i in cells.size():
        if cell_colors[i] != -1:
            living.append(i)
    living.shuffle()
    var to_drop := mini(count, maxi(living.size() - MIN_LIVING_TILES, 0))
    for i in to_drop:
        _drop_tile(living[i])


func _drop_tile(index: int) -> void:
    cell_colors[index] = -1
    var cell: Panel = cells[index]
    cell.pivot_offset = cell.size / 2.0
    var fall := create_tween()
    fall.set_parallel()
    fall.tween_property(cell, "scale", Vector2(0.1, 0.1), 0.35)\
        .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
    fall.tween_property(cell, "rotation", randf_range(-1.3, 1.3), 0.35)
    fall.tween_property(cell, "modulate:a", 0.0, 0.35)


func _apply_round_colors(colors: Array) -> void:
    for i in cells.size():
        if colors[i] == -1:
            if cell_colors[i] != -1:
                _drop_tile(i)
        else:
            cell_colors[i] = colors[i]
            _paint_cell(i, false)


func _start_round() -> void:
    round_num += 1
    if round_num > 1:
        _drop_random_tiles(2 + round_num)
    for i in cells.size():
        if cell_colors[i] == -1:
            continue
        cell_colors[i] = randi() % CHAOS_COLORS.size()
        _paint_cell(i, false)
    target = randi() % CHAOS_COLORS.size()
    round_label.text = "Runda %d" % round_num
    banner_label.text = "Stan na: %s" % COLOR_NAMES[target]
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(CHAOS_COLORS[target].darkened(0.15), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    var pulse := create_tween()
    pulse.tween_property(banner, "scale", Vector2(1.04, 1.04), 0.12)
    pulse.tween_property(banner, "scale", Vector2.ONE, 0.12)
    banner.pivot_offset = banner.size / 2.0
    round_time = clampf(3.4 - 0.25 * round_num, 1.2, 3.4)
    timer = round_time
    phase = "move"
    if _net:
        NetworkManager.broadcast_minigame_event("round", {
            "colors": cell_colors.duplicate(), "target": target,
            "time": round_time, "num": round_num,
        })


func _process(delta: float) -> void:
    if phase != "move":
        return
    for pid in player_nodes:
        if not alive[pid]:
            continue
        if _net and pid != _my_pid:
            continue
        var direction := _read_direction(pid)
        var node: BearCharacter = player_nodes[pid]
        if direction != Vector2.ZERO:
            node.position += direction.normalized() * SPEED * delta
            node.position = node.position.clamp(
                ARENA.position + Vector2(18, 50),
                ARENA.position + ARENA.size - Vector2(18, 6)
            )
            node.rotation = sin(Time.get_ticks_msec() / 1000.0 * 15.0 + pid) * 0.09
        else:
            node.rotation = lerpf(node.rotation, 0.0, 12.0 * delta)
    if _net:
        if NetworkManager.is_server():
            var all_positions := {}
            for pid in player_nodes:
                all_positions[pid] = player_nodes[pid].position
            NetworkManager.broadcast_minigame_positions(all_positions)
        else:
            NetworkManager.send_minigame_position(player_nodes[_my_pid].position)
    timer -= delta
    timer_bar.size.x = 600.0 * maxf(timer, 0.0) / round_time
    if timer <= 0.0:
        if not _net or NetworkManager.is_server():
            _judge()
        else:
            phase = "wait"


func _read_direction(pid: int) -> Vector2:
    var direction := Vector2.ZERO
    var key_sets: Array = [KEY_SETS[pid]] if not _net else [KEY_SETS[0], KEY_SETS[1]]
    for keys in key_sets:
        if Input.is_physical_key_pressed(keys[0]):
            direction.y -= 1
        if Input.is_physical_key_pressed(keys[1]):
            direction.y += 1
        if Input.is_physical_key_pressed(keys[2]):
            direction.x -= 1
        if Input.is_physical_key_pressed(keys[3]):
            direction.x += 1
    return direction


func _on_net_positions(positions: Dictionary) -> void:
    for pid in positions:
        if pid == _my_pid and NetworkManager.is_client():
            continue
        if player_nodes.has(pid):
            player_nodes[pid].position = positions[pid]


func _on_net_event(kind: String, data: Dictionary) -> void:
    match kind:
        "round":
            round_num = data["num"]
            _apply_round_colors(data["colors"])
            target = data["target"]
            round_label.text = "Runda %d" % round_num
            banner_label.text = "Stan na: %s" % COLOR_NAMES[target]
            banner.add_theme_stylebox_override(
                "panel", UiStyle.flat(CHAOS_COLORS[target].darkened(0.15), 16, 3, Color(1, 1, 1, 0.85), 8)
            )
            round_time = data["time"]
            timer = round_time
            phase = "move"
        "elim":
            for pid in data["out"]:
                alive[pid] = false
                var pawn: BearCharacter = player_nodes[pid]
                pawn.show_emote("shock")
                var fall := create_tween()
                fall.set_parallel()
                fall.tween_property(pawn, "modulate:a", 0.25, 0.5)
                fall.tween_property(pawn, "rotation", PI / 2.0, 0.5)
                fall.tween_property(pawn, "scale", Vector2(0.6, 0.6), 0.5)
            for i in cells.size():
                if cell_colors[i] != -1 and cell_colors[i] != target:
                    _paint_cell(i, true)
        "finish":
            phase = "done"
            var ranking: Array = data["ranking"]
            if not ranking.is_empty():
                banner_label.text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]


func _judge() -> void:
    phase = "pause"
    var eliminated_now: Array = []
    for pid in player_nodes:
        if not alive[pid]:
            continue
        var feet: Vector2 = player_nodes[pid].position
        var col := clampi(int((feet.x - ARENA.position.x) / (ARENA.size.x / COLS)), 0, COLS - 1)
        var row := clampi(int((feet.y - ARENA.position.y) / (ARENA.size.y / ROWS)), 0, ROWS - 1)
        if cell_colors[row * COLS + col] != target:
            alive[pid] = false
            elimination_order.append(pid)
            eliminated_now.append(pid)
            var pawn: BearCharacter = player_nodes[pid]
            pawn.show_emote("shock")
            var fall := create_tween()
            fall.set_parallel()
            fall.tween_property(pawn, "modulate:a", 0.25, 0.5)
            fall.tween_property(pawn, "rotation", PI / 2.0, 0.5)
            fall.tween_property(pawn, "scale", Vector2(0.6, 0.6), 0.5)
    for i in cells.size():
        if cell_colors[i] != -1 and cell_colors[i] != target:
            _paint_cell(i, true)
    if _net:
        NetworkManager.broadcast_minigame_event("elim", {"out": eliminated_now})
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

    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(UiStyle.CARD, 16, 3, UiStyle.GOLD, 8)
    )
    if ranking.is_empty():
        banner_label.text = "Remis!"
    else:
        var winner := PlayerManager.get_player(ranking[0])
        banner_label.text = "Wygrywa: %s!" % winner["name"]
        var confetti := CPUParticles2D.new()
        confetti.amount = 140
        confetti.lifetime = 1.4
        confetti.one_shot = true
        confetti.explosiveness = 0.9
        confetti.direction = Vector2(0, -1)
        confetti.spread = 70.0
        confetti.initial_velocity_min = 250.0
        confetti.initial_velocity_max = 520.0
        confetti.gravity = Vector2(0, 620)
        confetti.scale_amount_min = 2.5
        confetti.scale_amount_max = 5.0
        confetti.color = UiStyle.GOLD
        confetti.position = player_nodes[ranking[0]].position - Vector2(0, 26)
        confetti.emitting = true
        add_child(confetti)
    if _net:
        NetworkManager.broadcast_minigame_event("finish", {"ranking": ranking})
    await get_tree().create_timer(1.6).timeout
    MinigameManager.report_finished(ranking)

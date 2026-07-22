extends Control

# Minigame: Smiertelna Linia (FFA, 2-4 hotseat).
# Tron-style: you leave a permanent trail. Touching any trail or the
# wall ends your run. Last bear rolling wins.

const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const SPEED := 175.0
const CELL := 6.0
const PENDING := 5
const TIME_LIMIT := 50.0

var players := {}
var occupancy := {}
var elimination_order: Array = []
var phase := "countdown"
var countdown := 2.0
var time_left := TIME_LIMIT

var banner_label: Label
var trail_layer: Control


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var court := Panel.new()
    court.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.07, 0.09, 0.14), 20, 6, UiStyle.GOLD_DARK, 10)
    )
    court.position = ARENA.position - Vector2(12, 12)
    court.size = ARENA.size + Vector2(24, 24)
    add_child(court)

    trail_layer = Control.new()
    trail_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
    trail_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    trail_layer.draw.connect(_draw_trails)
    add_child(trail_layer)

    var banner := Panel.new()
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.16, 0.2, 0.35), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 74)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 26, Color.WHITE)
    banner.add_child(banner_label)

    var title := Label.new()
    title.text = "Smiertelna Linia"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.75))
    title.position = Vector2(60, 44)
    add_child(title)

    var starts := [
        [ARENA.position + Vector2(80, 100), Vector2.RIGHT],
        [ARENA.position + Vector2(ARENA.size.x - 80, ARENA.size.y - 100), Vector2.LEFT],
        [ARENA.position + Vector2(80, ARENA.size.y - 100), Vector2.RIGHT],
        [ARENA.position + Vector2(ARENA.size.x - 80, 100), Vector2.LEFT],
    ]
    for player in PlayerManager.players:
        var pid: int = player["id"]
        players[pid] = {
            "pos": starts[pid][0],
            "dir": starts[pid][1],
            "color": player["color"],
            "trail": [starts[pid][0]],
            "pending": [],
            "alive": true,
        }


func _process(delta: float) -> void:
    if phase == "countdown":
        countdown -= delta
        banner_label.text = "Start za %.1f..." % maxf(countdown, 0.0)
        if countdown <= 0.0:
            phase = "play"
            banner_label.text = "Unikaj linii!"
        trail_layer.queue_redraw()
        return
    if phase != "play":
        return

    for pid in players:
        var data: Dictionary = players[pid]
        if not data["alive"]:
            continue
        var keys: Array = KEY_SETS[pid]
        var wanted := Vector2.ZERO
        if Input.is_physical_key_pressed(keys[0]):
            wanted = Vector2.UP
        elif Input.is_physical_key_pressed(keys[1]):
            wanted = Vector2.DOWN
        elif Input.is_physical_key_pressed(keys[2]):
            wanted = Vector2.LEFT
        elif Input.is_physical_key_pressed(keys[3]):
            wanted = Vector2.RIGHT
        if wanted != Vector2.ZERO and wanted != -data["dir"] and wanted != data["dir"]:
            data["dir"] = wanted
            data["trail"].append(data["pos"])

        var new_pos: Vector2 = data["pos"] + data["dir"] * SPEED * delta
        var cell := Vector2i(int(new_pos.x / CELL), int(new_pos.y / CELL))
        var inside := ARENA.grow(-4).has_point(new_pos)
        if not inside or (occupancy.has(cell) and not data["pending"].has(cell)):
            _eliminate(pid)
            continue
        if data["pending"].is_empty() or data["pending"][data["pending"].size() - 1] != cell:
            data["pending"].append(cell)
            if data["pending"].size() > PENDING:
                occupancy[data["pending"].pop_front()] = true
        data["pos"] = new_pos
    trail_layer.queue_redraw()

    time_left -= delta
    var alive_count := 0
    for pid in players:
        if players[pid]["alive"]:
            alive_count += 1
    if alive_count <= 1 or time_left <= 0.0:
        _finish()


func _eliminate(pid: int) -> void:
    players[pid]["alive"] = false
    elimination_order.append(pid)
    banner_label.text = "%s przecina linie!" % PlayerManager.get_player(pid)["name"]


func _draw_trails() -> void:
    for pid in players:
        var data: Dictionary = players[pid]
        var points: PackedVector2Array = PackedVector2Array(data["trail"])
        points.append(data["pos"])
        var color: Color = data["color"]
        if not data["alive"]:
            color.a = 0.35
        if points.size() >= 2:
            trail_layer.draw_polyline(points, color, 5.0, true)
        trail_layer.draw_circle(data["pos"], 9, color)
        trail_layer.draw_circle(data["pos"] + Vector2(-6, -7), 4, color)
        trail_layer.draw_circle(data["pos"] + Vector2(6, -7), 4, color)
        trail_layer.draw_arc(data["pos"], 9, 0, TAU, 20, Color(1, 1, 1, 0.9), 2, true)
        if not data["alive"]:
            trail_layer.draw_line(data["pos"] + Vector2(-6, -6), data["pos"] + Vector2(6, 6), Color.RED, 3, true)
            trail_layer.draw_line(data["pos"] + Vector2(6, -6), data["pos"] + Vector2(-6, 6), Color.RED, 3, true)


func _finish() -> void:
    phase = "done"
    var ranking: Array = []
    for pid in players:
        if players[pid]["alive"]:
            ranking.append(pid)
    var eliminated := elimination_order.duplicate()
    eliminated.reverse()
    ranking.append_array(eliminated)
    if not ranking.is_empty():
        banner_label.text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]
    await get_tree().create_timer(1.4).timeout
    MinigameManager.report_finished(ranking)

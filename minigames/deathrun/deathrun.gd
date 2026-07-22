extends Control

# Minigame: Deathrun / Sabotazysta (ONE_VS_ALL, 2-4 hotseat).
# One random player is the Saboteur and triggers traps WITH THE MOUSE.
# The rest run with the keyboard from start to finish, dodging traps.

const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const TRACK_START_X := 280.0
const FINISH_X := 1052.0
const SPEED := 290.0
const TRAP_COUNT := 6
const WARNING_TIME := 0.45
const ACTIVE_TIME := 0.7
const COOLDOWN_TIME := 2.2
const TIME_LIMIT := 45.0

enum Trap { IDLE, WARNING, ACTIVE, COOLDOWN }

var saboteur := -1
var runners: Array = []
var runner_nodes := {}
var runner_state := {}
var finish_order: Array = []
var trap_zones: Array = []
var trap_states: Array = []
var trap_timers: Array = []
var time_left := TIME_LIMIT
var phase := "play"

var banner_label: Label
var timer_bar: Panel


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var track := Panel.new()
    track.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.32, 0.3, 0.35), 20, 6, Color(0.2, 0.18, 0.22), 10)
    )
    track.position = ARENA.position - Vector2(12, 12)
    track.size = ARENA.size + Vector2(24, 24)
    add_child(track)

    var start_zone := ColorRect.new()
    start_zone.color = Color(0.35, 0.6, 0.4, 0.7)
    start_zone.position = ARENA.position
    start_zone.size = Vector2(TRACK_START_X - ARENA.position.x - 20, ARENA.size.y)
    add_child(start_zone)

    var meta := ColorRect.new()
    meta.color = Color(0.95, 0.78, 0.3, 0.85)
    meta.position = Vector2(FINISH_X, ARENA.position.y)
    meta.size = Vector2(ARENA.end.x - FINISH_X, ARENA.size.y)
    add_child(meta)

    var meta_label := Label.new()
    meta_label.text = "M\nE\nT\nA"
    meta_label.position = Vector2(FINISH_X + 24, ARENA.position.y + 140)
    UiStyle.title_look(meta_label, 24, Color(0.2, 0.15, 0.05))
    add_child(meta_label)

    var zone_width := (FINISH_X - TRACK_START_X) / TRAP_COUNT
    for i in TRAP_COUNT:
        var zone := Panel.new()
        zone.position = Vector2(TRACK_START_X + i * zone_width + 4, ARENA.position.y + 4)
        zone.size = Vector2(zone_width - 8, ARENA.size.y - 8)
        zone.mouse_filter = Control.MOUSE_FILTER_STOP
        zone.gui_input.connect(_on_zone_input.bind(i))
        add_child(zone)
        trap_zones.append(zone)
        trap_states.append(Trap.IDLE)
        trap_timers.append(0.0)
        _paint_zone(i)

    var players := PlayerManager.get_player_ids()
    saboteur = players.pick_random()
    for pid in players:
        if pid == saboteur:
            continue
        runners.append(pid)
        var bear := BearCharacter.new()
        bear.base_color = PlayerManager.get_player(pid)["color"]
        bear.accessory = PlayerManager.get_player(pid)["accessory"]
        bear.scale = Vector2(0.85, 0.85)
        bear.position = _start_position(pid)
        add_child(bear)
        runner_nodes[pid] = bear
        runner_state[pid] = {"finished": false, "best_x": bear.position.x}

    var banner := Panel.new()
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.45, 0.2, 0.4), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    banner.position = Vector2(280, 24)
    banner.size = Vector2(720, 74)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 23, Color.WHITE)
    banner_label.text = "Sabotazysta: %s (MYSZKA — klikaj strefy!)" % PlayerManager.get_player(saboteur)["name"]
    banner.add_child(banner_label)

    timer_bar = Panel.new()
    timer_bar.add_theme_stylebox_override("panel", UiStyle.flat(UiStyle.GOLD, 4))
    timer_bar.position = Vector2(280, 104)
    timer_bar.size = Vector2(720, 10)
    add_child(timer_bar)

    var title := Label.new()
    title.text = "Deathrun"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.75))
    title.position = Vector2(60, 44)
    add_child(title)


func _start_position(pid: int) -> Vector2:
    return Vector2(ARENA.position.x + 50, ARENA.position.y + 110 + pid * 90)


func _paint_zone(index: int) -> void:
    var style: StyleBoxFlat
    match trap_states[index]:
        Trap.IDLE:
            style = UiStyle.flat(Color(0.42, 0.4, 0.46, 0.55), 10, 2, Color(1, 1, 1, 0.18))
        Trap.WARNING:
            style = UiStyle.flat(Color(0.95, 0.8, 0.25, 0.75), 10, 3, Color(1, 1, 1, 0.7))
        Trap.ACTIVE:
            style = UiStyle.flat(Color(0.9, 0.22, 0.2, 0.85), 10, 3, Color(1, 0.9, 0.4, 0.9))
        Trap.COOLDOWN:
            style = UiStyle.flat(Color(0.25, 0.24, 0.3, 0.55), 10)
    trap_zones[index].add_theme_stylebox_override("panel", style)


func _on_zone_input(event: InputEvent, index: int) -> void:
    if phase != "play":
        return
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if trap_states[index] == Trap.IDLE:
            trap_states[index] = Trap.WARNING
            trap_timers[index] = WARNING_TIME
            _paint_zone(index)


func _process(delta: float) -> void:
    if phase != "play":
        return
    for i in TRAP_COUNT:
        if trap_states[i] == Trap.IDLE:
            continue
        trap_timers[i] -= delta
        if trap_timers[i] <= 0.0:
            match trap_states[i]:
                Trap.WARNING:
                    trap_states[i] = Trap.ACTIVE
                    trap_timers[i] = ACTIVE_TIME
                Trap.ACTIVE:
                    trap_states[i] = Trap.COOLDOWN
                    trap_timers[i] = COOLDOWN_TIME
                Trap.COOLDOWN:
                    trap_states[i] = Trap.IDLE
            _paint_zone(i)

    for pid in runners:
        if runner_state[pid]["finished"]:
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
        var node: BearCharacter = runner_nodes[pid]
        if direction != Vector2.ZERO:
            node.position += direction.normalized() * SPEED * delta
            node.position = node.position.clamp(
                ARENA.position + Vector2(16, 48),
                ARENA.position + ARENA.size - Vector2(16, 4)
            )
            node.rotation = sin(Time.get_ticks_msec() / 1000.0 * 15.0 + pid) * 0.09
        else:
            node.rotation = lerpf(node.rotation, 0.0, 12.0 * delta)
        runner_state[pid]["best_x"] = maxf(runner_state[pid]["best_x"], node.position.x)

        var zone_index := _zone_at(node.position.x)
        if zone_index >= 0 and trap_states[zone_index] == Trap.ACTIVE:
            node.position = _start_position(pid)
            node.show_emote("shock")
        if node.position.x >= FINISH_X:
            runner_state[pid]["finished"] = true
            finish_order.append(pid)
            node.show_emote("star")
            banner_label.text = "%s na mecie!" % PlayerManager.get_player(pid)["name"]

    time_left -= delta
    timer_bar.size.x = 720.0 * maxf(time_left, 0.0) / TIME_LIMIT
    var all_done := true
    for pid in runners:
        if not runner_state[pid]["finished"]:
            all_done = false
    if all_done or time_left <= 0.0:
        _finish()


func _zone_at(x: float) -> int:
    if x < TRACK_START_X or x >= FINISH_X:
        return -1
    var zone_width := (FINISH_X - TRACK_START_X) / TRAP_COUNT
    return clampi(int((x - TRACK_START_X) / zone_width), 0, TRAP_COUNT - 1)


func _finish() -> void:
    phase = "done"
    var unfinished := runners.filter(func(pid): return not runner_state[pid]["finished"])
    unfinished.sort_custom(
        func(a, b): return runner_state[a]["best_x"] > runner_state[b]["best_x"]
    )
    var runner_ranking := finish_order.duplicate()
    runner_ranking.append_array(unfinished)
    var ranking: Array = []
    if finish_order.size() * 2 <= runners.size():
        ranking.append(saboteur)
        ranking.append_array(runner_ranking)
        banner_label.text = "Sabotazysta %s wygrywa!" % PlayerManager.get_player(saboteur)["name"]
    else:
        ranking.append_array(runner_ranking)
        ranking.append(saboteur)
        banner_label.text = "Biegacze wygrywaja! Pierwszy: %s" % (
            PlayerManager.get_player(runner_ranking[0])["name"] if not runner_ranking.is_empty() else "?"
        )
    await get_tree().create_timer(1.6).timeout
    MinigameManager.report_finished(ranking)

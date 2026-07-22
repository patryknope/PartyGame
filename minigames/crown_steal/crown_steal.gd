extends Control

# Minigame: Kradziez Korony (FFA, 2-4 players hotseat).
# A crown appears in the middle. Grab it and hold on — whoever wears
# it the longest during the round wins. Touch the wearer to steal it.

const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const SPEED := 310.0
const HOLDER_SPEED := 268.0
const GRAB_RADIUS := 34.0
const DURATION := 40.0
const SPAWN_OFFSETS: Array[Vector2] = [
    Vector2(-220, -80), Vector2(220, -80), Vector2(-220, 80), Vector2(220, 80),
]

var player_nodes := {}
var hold_times := {}
var crown_holder := -1
var steal_cooldown := 0.0
var time_left := DURATION
var phase := "play"

var banner_label: Label
var timer_bar: Panel
var scores_label: Label


class CrownMarker extends Node2D:
    func _ready() -> void:
        var bob := create_tween().set_loops()
        bob.tween_property(self, "rotation", 0.12, 0.5)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        bob.tween_property(self, "rotation", -0.12, 0.5)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    func _draw() -> void:
        var gold := Color(0.99, 0.83, 0.28)
        draw_colored_polygon(
            PackedVector2Array([
                Vector2(-14, 6), Vector2(-14, -6), Vector2(-7, 0), Vector2(0, -10),
                Vector2(7, 0), Vector2(14, -6), Vector2(14, 6),
            ]),
            gold
        )
        draw_circle(Vector2(-14, -8), 2.5, gold)
        draw_circle(Vector2(0, -12), 2.5, gold)
        draw_circle(Vector2(14, -8), 2.5, gold)
        draw_circle(Vector2(0, 1), 2.8, Color(0.85, 0.25, 0.3))


var crown_marker: CrownMarker
var crown_spot: Vector2


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

    var banner := Panel.new()
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.75, 0.58, 0.15), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 62)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 26, Color.WHITE)
    banner_label.text = "Zloto korony czeka!"
    banner.add_child(banner_label)

    timer_bar = Panel.new()
    timer_bar.add_theme_stylebox_override("panel", UiStyle.flat(UiStyle.GOLD, 4))
    timer_bar.position = Vector2(340, 92)
    timer_bar.size = Vector2(600, 10)
    add_child(timer_bar)

    scores_label = Label.new()
    scores_label.position = Vector2(0, 110)
    scores_label.size = Vector2(1280, 26)
    scores_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(scores_label, 18, UiStyle.CREAM)
    add_child(scores_label)

    var title := Label.new()
    title.text = "Kradziez Korony"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.75))
    title.position = Vector2(60, 40)
    add_child(title)

    for player in PlayerManager.players:
        var pid: int = player["id"]
        var bear := BearCharacter.new()
        bear.base_color = player["color"]
        bear.accessory = pid
        bear.scale = Vector2(0.9, 0.9)
        bear.position = ARENA.get_center() + SPAWN_OFFSETS[pid]
        add_child(bear)
        player_nodes[pid] = bear
        hold_times[pid] = 0.0

    crown_spot = ARENA.get_center()
    crown_marker = CrownMarker.new()
    crown_marker.position = crown_spot
    add_child(crown_marker)


func _process(delta: float) -> void:
    if phase != "play":
        return
    for pid in player_nodes:
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
            var speed := HOLDER_SPEED if pid == crown_holder else SPEED
            node.position += direction.normalized() * speed * delta
            node.position = node.position.clamp(
                ARENA.position + Vector2(18, 50),
                ARENA.position + ARENA.size - Vector2(18, 6)
            )
            node.rotation = sin(Time.get_ticks_msec() / 1000.0 * 15.0 + pid) * 0.09
        else:
            node.rotation = lerpf(node.rotation, 0.0, 12.0 * delta)

    steal_cooldown -= delta
    if crown_holder == -1:
        for pid in player_nodes:
            if player_nodes[pid].position.distance_to(crown_spot) < GRAB_RADIUS:
                _crown_to(pid)
                break
    else:
        hold_times[crown_holder] += delta
        crown_marker.position = player_nodes[crown_holder].position - Vector2(0, 64)
        if steal_cooldown <= 0.0:
            for pid in player_nodes:
                if pid == crown_holder:
                    continue
                var distance: float = player_nodes[pid].position.distance_to(
                    player_nodes[crown_holder].position
                )
                if distance < GRAB_RADIUS:
                    _crown_to(pid)
                    break

    var parts: Array[String] = []
    for player in PlayerManager.players:
        parts.append("%s %.1fs" % [player["name"], hold_times[player["id"]]])
    scores_label.text = "    ".join(parts)

    time_left -= delta
    timer_bar.size.x = 600.0 * maxf(time_left, 0.0) / DURATION
    if time_left <= 0.0:
        _finish()


func _crown_to(player_id: int) -> void:
    crown_holder = player_id
    steal_cooldown = 0.8
    player_nodes[player_id].show_emote("happy")
    banner_label.text = "Korone ma: %s!" % PlayerManager.get_player(player_id)["name"]


func _finish() -> void:
    phase = "done"
    var ranking: Array = hold_times.keys()
    ranking.sort_custom(func(a, b): return hold_times[a] > hold_times[b])
    banner_label.text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]

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

    await get_tree().create_timer(1.5).timeout
    MinigameManager.report_finished(ranking)

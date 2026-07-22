extends Control

# Minigame: Goracy Ziemniak (FFA, 2-4 players hotseat).
# One player holds a bomb with a hidden fuse — pass it by touching
# another player. When it explodes, the holder is out. Last bear wins.

const KEY_SETS: Array = [
    [KEY_W, KEY_S, KEY_A, KEY_D],
    [KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT],
    [KEY_T, KEY_G, KEY_F, KEY_H],
    [KEY_I, KEY_K, KEY_J, KEY_L],
]
const ARENA := Rect2(140, 160, 1000, 470)
const SPEED := 300.0
const HOLDER_SPEED := 356.0
const PASS_RADIUS := 38.0
const SPAWN_OFFSETS: Array[Vector2] = [
    Vector2(-220, -80), Vector2(220, -80), Vector2(-220, 80), Vector2(220, 80),
]

var player_nodes := {}
var alive := {}
var elimination_order: Array = []
var holder := -1
var fuse := 0.0
var pass_cooldown := 0.0
var phase := "play"

var banner_label: Label


class BombMarker extends Node2D:
    func _ready() -> void:
        var pulse := create_tween().set_loops()
        pulse.tween_property(self, "scale", Vector2(1.25, 1.25), 0.22)
        pulse.tween_property(self, "scale", Vector2.ONE, 0.22)

    func _draw() -> void:
        draw_circle(Vector2.ZERO, 11, Color(0.12, 0.12, 0.15))
        draw_circle(Vector2(-3, -3), 3.5, Color(1, 1, 1, 0.35))
        draw_line(Vector2(4, -9), Vector2(9, -16), Color(0.55, 0.4, 0.25), 3, true)
        draw_circle(Vector2(10, -18), 3.5, Color(1, 0.55, 0.15))


var bomb_marker: BombMarker


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
        "panel", UiStyle.flat(Color(0.72, 0.25, 0.2), 16, 3, Color(1, 1, 1, 0.85), 8)
    )
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 74)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 28, Color.WHITE)
    banner.add_child(banner_label)

    var title := Label.new()
    title.text = "Goracy Ziemniak"
    UiStyle.title_look(title, 22, Color(1, 1, 1, 0.75))
    title.position = Vector2(60, 44)
    add_child(title)

    for player in PlayerManager.players:
        var pid: int = player["id"]
        var bear := BearCharacter.new()
        bear.base_color = player["color"]
        bear.scale = Vector2(0.9, 0.9)
        bear.position = ARENA.get_center() + SPAWN_OFFSETS[pid]
        add_child(bear)
        player_nodes[pid] = bear
        alive[pid] = true

    bomb_marker = BombMarker.new()
    add_child(bomb_marker)

    _give_bomb(PlayerManager.get_player_ids().pick_random())
    fuse = randf_range(4.5, 7.0)


func _give_bomb(player_id: int) -> void:
    holder = player_id
    pass_cooldown = 0.7
    banner_label.text = "Bombe ma: %s!" % PlayerManager.get_player(player_id)["name"]


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
            var speed := HOLDER_SPEED if pid == holder else SPEED
            node.position += direction.normalized() * speed * delta
            node.position = node.position.clamp(
                ARENA.position + Vector2(18, 50),
                ARENA.position + ARENA.size - Vector2(18, 6)
            )
            node.rotation = sin(Time.get_ticks_msec() / 1000.0 * 15.0 + pid) * 0.09
        else:
            node.rotation = lerpf(node.rotation, 0.0, 12.0 * delta)

    bomb_marker.position = player_nodes[holder].position - Vector2(0, 62)

    pass_cooldown -= delta
    if pass_cooldown <= 0.0:
        for pid in player_nodes:
            if pid == holder or not alive[pid]:
                continue
            if player_nodes[holder].position.distance_to(player_nodes[pid].position) < PASS_RADIUS:
                _give_bomb(pid)
                break

    fuse -= delta
    if fuse <= 0.0:
        _explode()


func _explode() -> void:
    phase = "pause"
    var victim := holder
    alive[victim] = false
    elimination_order.append(victim)
    banner_label.text = "BUM! %s odpada!" % PlayerManager.get_player(victim)["name"]

    var blast := CPUParticles2D.new()
    blast.amount = 90
    blast.lifetime = 0.7
    blast.one_shot = true
    blast.explosiveness = 1.0
    blast.spread = 180.0
    blast.initial_velocity_min = 180.0
    blast.initial_velocity_max = 420.0
    blast.gravity = Vector2(0, 400)
    blast.scale_amount_min = 2.0
    blast.scale_amount_max = 4.5
    blast.color = Color(1, 0.5, 0.15)
    blast.position = player_nodes[victim].position - Vector2(0, 24)
    blast.emitting = true
    add_child(blast)

    var pawn: BearCharacter = player_nodes[victim]
    var fall := create_tween()
    fall.set_parallel()
    fall.tween_property(pawn, "modulate:a", 0.25, 0.5)
    fall.tween_property(pawn, "rotation", PI / 2.0, 0.5)
    fall.tween_property(pawn, "scale", Vector2(0.6, 0.6), 0.5)

    var survivors: Array = []
    for pid in alive:
        if alive[pid]:
            survivors.append(pid)
    if survivors.size() <= 1:
        _finish(survivors)
        return
    await get_tree().create_timer(1.2).timeout
    _give_bomb(survivors.pick_random())
    fuse = randf_range(3.5, 6.0)
    phase = "play"


func _finish(survivors: Array) -> void:
    phase = "done"
    bomb_marker.visible = false
    var ranking: Array = survivors.duplicate()
    var eliminated := elimination_order.duplicate()
    eliminated.reverse()
    ranking.append_array(eliminated)
    if not ranking.is_empty():
        banner_label.text = "Wygrywa: %s!" % PlayerManager.get_player(ranking[0])["name"]
    await get_tree().create_timer(1.4).timeout
    MinigameManager.report_finished(ranking)

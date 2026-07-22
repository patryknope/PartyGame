class_name Scenery
extends Control

# Decorative landscape layer: sky, sun, mountains, meadow, ponds,
# trees, flowers and drifting clouds. Pure visuals, no logic.

const SKY := Color(0.55, 0.79, 0.93)
const MEADOW := Color(0.45, 0.71, 0.35)
const HORIZON_Y := 195.0

const PINES: Array[Vector2] = [
    Vector2(120, 500), Vector2(165, 540), Vector2(1145, 470),
    Vector2(1180, 530), Vector2(470, 255), Vector2(540, 230),
]
const TREES: Array[Vector2] = [
    Vector2(90, 440), Vector2(1200, 420), Vector2(420, 290),
    Vector2(150, 620), Vector2(1120, 615),
]
const FLOWER_COLORS: Array[Color] = [
    Color(0.95, 0.5, 0.55), Color(0.98, 0.85, 0.35), Color(0.75, 0.55, 0.9), Color(1, 1, 1),
]


class Cloud extends Node2D:
    var drift := 30.0

    func _ready() -> void:
        var tween := create_tween().set_loops()
        tween.tween_property(self, "position:x", position.x + drift, 7.0)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(self, "position:x", position.x - drift, 7.0)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    func _draw() -> void:
        var color := Color(1, 1, 1, 0.92)
        draw_circle(Vector2(0, 0), 26, color)
        draw_circle(Vector2(25, 6), 19, color)
        draw_circle(Vector2(-27, 8), 17, color)
        draw_circle(Vector2(4, 12), 22, color)


class Bird extends Node2D:
    var speed := 60.0
    var flap := 0.0

    func _process(delta: float) -> void:
        flap += delta * 9.0
        position.x += speed * delta
        position.y += sin(flap * 0.6) * 0.25
        if position.x > 1340:
            position.x = -60
            position.y = 46 + randf() * 120
        queue_redraw()

    func _draw() -> void:
        var ink := Color(0.2, 0.22, 0.32, 0.9)
        var wing := sin(flap) * 7.0
        draw_line(Vector2(-9, 0), Vector2(0, -wing), ink, 2.6, true)
        draw_line(Vector2(0, -wing), Vector2(9, 0), ink, 2.6, true)


class Butterfly extends Node2D:
    var origin := Vector2.ZERO
    var wing_color := Color(0.92, 0.55, 0.8)
    var t := randf() * 10.0

    func _process(delta: float) -> void:
        t += delta
        position = origin + Vector2(sin(t * 0.8) * 44.0, sin(t * 1.7) * 20.0)
        queue_redraw()

    func _draw() -> void:
        var spread := absf(sin(t * 11.0)) * 0.7 + 0.35
        draw_set_transform(Vector2(-2, 0), -0.25, Vector2(spread, 1.0))
        draw_circle(Vector2(-4, 0), 5, wing_color)
        draw_set_transform(Vector2(2, 0), 0.25, Vector2(spread, 1.0))
        draw_circle(Vector2(4, 0), 5, wing_color)
        draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
        draw_circle(Vector2.ZERO, 1.7, Color(0.2, 0.2, 0.25))


class RiverFlow extends Node2D:
    const POINTS: Array[Vector2] = [
        Vector2(340, 206), Vector2(420, 300), Vector2(520, 380),
        Vector2(640, 430), Vector2(760, 452),
    ]
    const FALL_TOP := Vector2(340, 152)

    var _offset := 0.0

    func _process(delta: float) -> void:
        _offset = fmod(_offset + delta * 46.0, 26.0)
        queue_redraw()

    func _draw() -> void:
        var deep := Color(0.25, 0.48, 0.68)
        var light := Color(0.45, 0.68, 0.88)
        var packed := PackedVector2Array(POINTS)
        draw_polyline(packed, deep, 16, true)
        draw_polyline(packed, light, 10, true)

        draw_rect(Rect2(FALL_TOP - Vector2(7, 0), Vector2(14, POINTS[0].y - FALL_TOP.y)), light)
        draw_rect(Rect2(FALL_TOP - Vector2(3, 0), Vector2(3, POINTS[0].y - FALL_TOP.y)), Color(1, 1, 1, 0.7))
        var fall_phase := fmod(_offset, 14.0)
        for i in 4:
            var y := FALL_TOP.y + fall_phase + i * 14.0
            if y < POINTS[0].y:
                draw_circle(Vector2(FALL_TOP.x + 2, y), 2.2, Color(1, 1, 1, 0.85))
        var foam_pulse := 2.0 + sin(_offset * 0.6) * 0.8
        draw_circle(POINTS[0] + Vector2(-6, 2), foam_pulse + 2.0, Color(1, 1, 1, 0.6))
        draw_circle(POINTS[0] + Vector2(6, 3), foam_pulse + 1.0, Color(1, 1, 1, 0.5))

        for i in range(POINTS.size() - 1):
            var from := POINTS[i]
            var to := POINTS[i + 1]
            var length := from.distance_to(to)
            var direction := (to - from) / length
            var travelled := _offset
            while travelled + 7.0 < length:
                draw_line(
                    from + direction * travelled,
                    from + direction * (travelled + 7.0),
                    Color(1, 1, 1, 0.55),
                    2.5,
                    true
                )
                travelled += 26.0


func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    for i in 3:
        var cloud := Cloud.new()
        cloud.position = Vector2(190 + i * 420, 62 + (i % 2) * 38)
        cloud.drift = 26.0 + i * 14.0
        add_child(cloud)
    add_child(RiverFlow.new())
    for i in 4:
        var bird := Bird.new()
        bird.position = Vector2(randf() * 1280.0, 50 + i * 32.0)
        bird.speed = 46.0 + i * 14.0
        add_child(bird)
    var butterfly_colors: Array[Color] = [
        Color(0.92, 0.55, 0.8), Color(0.55, 0.7, 0.95), Color(0.98, 0.8, 0.4),
    ]
    var butterfly_spots: Array[Vector2] = [
        Vector2(200, 560), Vector2(1080, 540), Vector2(480, 270),
    ]
    for i in 3:
        var butterfly := Butterfly.new()
        butterfly.origin = butterfly_spots[i]
        butterfly.wing_color = butterfly_colors[i]
        add_child(butterfly)


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), SKY)
    draw_circle(Vector2(1180, 72), 54, Color(1.0, 0.93, 0.55, 0.35))
    draw_circle(Vector2(1180, 72), 34, Color(1.0, 0.88, 0.42))

    _mountain(Vector2(140, HORIZON_Y + 8), 240, 128, Color(0.52, 0.58, 0.72))
    _mountain(Vector2(340, HORIZON_Y + 8), 300, 158, Color(0.45, 0.51, 0.66))
    _mountain(Vector2(560, HORIZON_Y + 8), 250, 120, Color(0.55, 0.6, 0.74))
    _mountain(Vector2(780, HORIZON_Y + 8), 310, 165, Color(0.44, 0.5, 0.65))
    _mountain(Vector2(1010, HORIZON_Y + 8), 260, 135, Color(0.53, 0.59, 0.73))
    _mountain(Vector2(1190, HORIZON_Y + 8), 240, 110, Color(0.57, 0.62, 0.75))

    draw_rect(Rect2(0, HORIZON_Y, size.x, size.y - HORIZON_Y), MEADOW)
    _hill(Vector2(280, HORIZON_Y + 12), 300, Color(0.52, 0.78, 0.4))
    _hill(Vector2(900, HORIZON_Y + 8), 340, Color(0.5, 0.76, 0.38))

    _pond(Vector2(760, 455))
    for pos in TREES:
        _tree(pos)
    for pos in PINES:
        _pine(pos)
    for i in 26:
        var pos := Vector2(60 + (i * 211) % 1170, HORIZON_Y + 55 + (i * 97) % 440)
        _flower(pos, FLOWER_COLORS[i % FLOWER_COLORS.size()])


func _mountain(base: Vector2, width: float, height: float, color: Color) -> void:
    var half := width / 2.0
    draw_colored_polygon(
        PackedVector2Array([base + Vector2(-half, 0), base + Vector2(0, -height), base + Vector2(half, 0)]),
        color
    )
    var cap := height * 0.26
    draw_colored_polygon(
        PackedVector2Array([
            base + Vector2(-half * 0.3, -height + cap),
            base + Vector2(0, -height),
            base + Vector2(half * 0.3, -height + cap),
        ]),
        Color(0.97, 0.97, 1.0)
    )


func _hill(center: Vector2, radius: float, color: Color) -> void:
    draw_set_transform(center, 0, Vector2(1, 0.22))
    draw_circle(Vector2.ZERO, radius, color)
    draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)


func _pond(center: Vector2) -> void:
    draw_set_transform(center, 0, Vector2(1, 0.5))
    draw_circle(Vector2.ZERO, 74, Color(0.25, 0.48, 0.68))
    draw_circle(Vector2.ZERO, 62, Color(0.36, 0.62, 0.85))
    draw_circle(Vector2(-18, -12), 16, Color(1, 1, 1, 0.35))
    draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)


func _pine(base: Vector2) -> void:
    draw_rect(Rect2(base + Vector2(-4, -8), Vector2(8, 12)), Color(0.45, 0.3, 0.18))
    var green := Color(0.16, 0.45, 0.25)
    for i in 3:
        var y := -6.0 - i * 16.0
        var half := 24.0 - i * 5.0
        draw_colored_polygon(
            PackedVector2Array([
                base + Vector2(-half, y),
                base + Vector2(0, y - 24),
                base + Vector2(half, y),
            ]),
            green.lightened(i * 0.09)
        )


func _tree(base: Vector2) -> void:
    draw_rect(Rect2(base + Vector2(-5, -16), Vector2(10, 18)), Color(0.5, 0.34, 0.2))
    var green := Color(0.28, 0.6, 0.3)
    draw_circle(base + Vector2(-13, -28), 16, green.darkened(0.1))
    draw_circle(base + Vector2(13, -28), 16, green)
    draw_circle(base + Vector2(0, -42), 19, green.lightened(0.08))


func _flower(pos: Vector2, color: Color) -> void:
    draw_circle(pos, 4.2, color)
    draw_circle(pos, 1.8, Color(1, 0.95, 0.6))

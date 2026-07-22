class_name BearCharacter
extends Node2D

# Cute vector-drawn bear mascot. The node position is the bear's feet.
# Idle bobbing, blinking, hop animation and a gold highlight ring.

var base_color := Color(0.8, 0.4, 0.3)
var accessory := -1
var highlight := false:
    set(value):
        highlight = value
        queue_redraw()

var _bob := 0.0:
    set(value):
        _bob = value
        queue_redraw()
var _eyes_closed := false


class EmoteBubble extends Node2D:
    var kind := "happy"

    func _ready() -> void:
        scale = Vector2(0.2, 0.2)
        var tween := create_tween()
        tween.tween_property(self, "scale", Vector2.ONE, 0.16)\
            .set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
        tween.tween_interval(1.0)
        tween.tween_property(self, "modulate:a", 0.0, 0.25)
        tween.finished.connect(queue_free)

    func _draw() -> void:
        var ink := Color(0.15, 0.13, 0.15)
        draw_circle(Vector2.ZERO, 13, Color(1, 1, 1, 0.96))
        draw_colored_polygon(
            PackedVector2Array([Vector2(-7, 9), Vector2(-3, 18), Vector2(1, 9)]),
            Color(1, 1, 1, 0.96)
        )
        match kind:
            "happy":
                draw_circle(Vector2(-4, -3), 1.6, ink)
                draw_circle(Vector2(4, -3), 1.6, ink)
                draw_arc(Vector2(0, 0), 6, 0.5, PI - 0.5, 12, ink, 2, true)
            "sad":
                draw_circle(Vector2(-4, -3), 1.6, ink)
                draw_circle(Vector2(4, -3), 1.6, ink)
                draw_arc(Vector2(0, 8), 6, PI + 0.5, TAU - 0.5, 12, ink, 2, true)
                draw_circle(Vector2(6, 2), 2, Color(0.4, 0.65, 0.95))
            "angry":
                draw_line(Vector2(-7, -5), Vector2(-2, -3), ink, 2, true)
                draw_line(Vector2(7, -5), Vector2(2, -3), ink, 2, true)
                draw_arc(Vector2(0, 8), 6, PI + 0.5, TAU - 0.5, 12, ink, 2, true)
            "shock":
                draw_rect(Rect2(-1.5, -8, 3, 9), Color(0.85, 0.25, 0.25))
                draw_circle(Vector2(0, 5), 1.8, Color(0.85, 0.25, 0.25))
            "coin":
                draw_circle(Vector2.ZERO, 7, Color(0.95, 0.78, 0.3))
                draw_arc(Vector2.ZERO, 4.5, 0, TAU, 16, Color(0.75, 0.56, 0.15), 1.6, true)
            "star":
                var points := PackedVector2Array()
                for i in 10:
                    var radius := 8.0 if i % 2 == 0 else 3.5
                    var angle := -PI / 2.0 + TAU * i / 10.0
                    points.append(Vector2(cos(angle), sin(angle)) * radius)
                draw_colored_polygon(points, Color(0.95, 0.78, 0.3))


func show_emote(kind: String) -> void:
    var bubble := EmoteBubble.new()
    bubble.kind = kind
    bubble.position = Vector2(17, -62)
    add_child(bubble)


func _ready() -> void:
    var idle := create_tween().set_loops()
    idle.tween_property(self, "_bob", -2.5, 0.85 + randf() * 0.3)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    idle.tween_property(self, "_bob", 0.0, 0.85 + randf() * 0.3)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    _schedule_blink()


func _schedule_blink() -> void:
    get_tree().create_timer(randf_range(1.6, 4.5)).timeout.connect(_blink)


func _blink() -> void:
    if not is_inside_tree():
        return
    _eyes_closed = true
    queue_redraw()
    await get_tree().create_timer(0.12).timeout
    if not is_inside_tree():
        return
    _eyes_closed = false
    queue_redraw()
    _schedule_blink()


func hop_to(target: Vector2, duration: float) -> Tween:
    var move := create_tween()
    move.tween_property(self, "position", target, duration)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    var hop := create_tween()
    hop.tween_property(self, "_bob", -13.0, duration * 0.5)\
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    hop.tween_property(self, "_bob", 0.0, duration * 0.5)\
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
    return move


func _draw() -> void:
    if highlight:
        draw_set_transform(Vector2(0, 2), 0, Vector2(1, 0.35))
        draw_circle(Vector2.ZERO, 24, Color(0.95, 0.78, 0.3, 0.55))
        draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
    draw_set_transform(Vector2(0, 2), 0, Vector2(1, 0.3))
    draw_circle(Vector2.ZERO, 15, Color(0, 0, 0, 0.22))
    draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

    var y := _bob
    var dark := base_color.darkened(0.35)
    var light := base_color.lightened(0.45)
    var ink := Color(0.12, 0.09, 0.08)

    draw_circle(Vector2(-8, y - 3), 5.5, dark)
    draw_circle(Vector2(8, y - 3), 5.5, dark)

    draw_set_transform(Vector2(0, y - 15), 0, Vector2(1, 1.15))
    draw_circle(Vector2.ZERO, 12, base_color)
    draw_set_transform(Vector2(0, y - 13), 0, Vector2(1, 1.1))
    draw_circle(Vector2.ZERO, 7, light)
    draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

    draw_circle(Vector2(-12.5, y - 17), 4.5, dark)
    draw_circle(Vector2(12.5, y - 17), 4.5, dark)

    draw_circle(Vector2(-10, y - 43), 6, base_color)
    draw_circle(Vector2(10, y - 43), 6, base_color)
    draw_circle(Vector2(-10, y - 43), 3, light)
    draw_circle(Vector2(10, y - 43), 3, light)

    draw_circle(Vector2(0, y - 33), 14, base_color)

    draw_set_transform(Vector2(0, y - 28.5), 0, Vector2(1, 0.75))
    draw_circle(Vector2.ZERO, 6.5, light)
    draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
    draw_circle(Vector2(0, y - 31), 2.3, ink)

    draw_circle(Vector2(-9.5, y - 30), 2.6, Color(1, 0.55, 0.55, 0.4))
    draw_circle(Vector2(9.5, y - 30), 2.6, Color(1, 0.55, 0.55, 0.4))

    if _eyes_closed:
        draw_line(Vector2(-7, y - 35), Vector2(-2.5, y - 35), ink, 1.6, true)
        draw_line(Vector2(2.5, y - 35), Vector2(7, y - 35), ink, 1.6, true)
    else:
        draw_circle(Vector2(-4.8, y - 35), 2.5, Color.WHITE)
        draw_circle(Vector2(4.8, y - 35), 2.5, Color.WHITE)
        draw_circle(Vector2(-4.4, y - 35), 1.35, ink)
        draw_circle(Vector2(5.2, y - 35), 1.35, ink)

    match accessory:
        0:
            var cap := Color(0.2, 0.3, 0.55)
            draw_circle(Vector2(0, y - 44), 7.5, cap)
            draw_rect(Rect2(Vector2(-1, y - 45), Vector2(13, 3.5)), cap.lightened(0.2))
        1:
            draw_arc(Vector2(-4.8, y - 35), 4.2, 0, TAU, 14, ink, 1.6, true)
            draw_arc(Vector2(4.8, y - 35), 4.2, 0, TAU, 14, ink, 1.6, true)
            draw_line(Vector2(-0.8, y - 35), Vector2(0.8, y - 35), ink, 1.6, true)
        2:
            var bow := Color(0.75, 0.2, 0.3)
            draw_colored_polygon(
                PackedVector2Array([Vector2(-8, y - 22), Vector2(-1, y - 19), Vector2(-8, y - 15)]), bow
            )
            draw_colored_polygon(
                PackedVector2Array([Vector2(8, y - 22), Vector2(1, y - 19), Vector2(8, y - 15)]), bow
            )
            draw_circle(Vector2(0, y - 19), 2.2, bow.lightened(0.25))
        3:
            for i in 5:
                var angle := TAU * i / 5.0
                draw_circle(Vector2(-11, y - 48) + Vector2(cos(angle), sin(angle)) * 3.4, 2.2, Color.WHITE)
            draw_circle(Vector2(-11, y - 48), 2.2, Color(0.98, 0.8, 0.3))

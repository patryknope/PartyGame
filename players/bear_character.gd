class_name BearCharacter
extends Node2D

# Cute vector-drawn bear mascot. The node position is the bear's feet.
# Idle bobbing, blinking, hop animation and a gold highlight ring.

var base_color := Color(0.8, 0.4, 0.3)
var highlight := false:
    set(value):
        highlight = value
        queue_redraw()

var _bob := 0.0:
    set(value):
        _bob = value
        queue_redraw()
var _eyes_closed := false


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

    if _eyes_closed:
        draw_line(Vector2(-7, y - 35), Vector2(-2.5, y - 35), ink, 1.6, true)
        draw_line(Vector2(2.5, y - 35), Vector2(7, y - 35), ink, 1.6, true)
    else:
        draw_circle(Vector2(-4.8, y - 35), 2.5, Color.WHITE)
        draw_circle(Vector2(4.8, y - 35), 2.5, Color.WHITE)
        draw_circle(Vector2(-4.4, y - 35), 1.35, ink)
        draw_circle(Vector2(5.2, y - 35), 1.35, ink)

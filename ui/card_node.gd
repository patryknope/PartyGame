class_name CardNode
extends Control

# Clickable playing card. Suits are drawn vectorially, rank as a label.

signal hold_toggled(index: int, held: bool)

const CARD_SIZE := Vector2(64, 92)

var card := {"rank": 14, "suit": 0}
var index := 0
var selectable := true
var held := false:
    set(value):
        held = value
        queue_redraw()

var _rank_label: Label


func _ready() -> void:
    custom_minimum_size = CARD_SIZE
    size = CARD_SIZE
    mouse_filter = Control.MOUSE_FILTER_STOP
    _rank_label = Label.new()
    _rank_label.position = Vector2(6, 2)
    _rank_label.add_theme_font_size_override("font_size", 20)
    add_child(_rank_label)
    refresh()


func refresh() -> void:
    if _rank_label == null:
        return
    _rank_label.text = PlayingCards.rank_label(card["rank"])
    _rank_label.add_theme_color_override("font_color", _suit_color())
    queue_redraw()


func _suit_color() -> Color:
    return Color(0.8, 0.16, 0.2) if card["suit"] in [1, 2] else Color(0.13, 0.13, 0.18)


func _gui_input(event: InputEvent) -> void:
    if not selectable:
        return
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        held = not held
        hold_toggled.emit(index, held)


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, CARD_SIZE), Color(0.98, 0.97, 0.94))
    var border := Color(0.95, 0.78, 0.3) if held else Color(0.55, 0.55, 0.6)
    draw_rect(Rect2(Vector2.ZERO, CARD_SIZE), border, false, 4.0 if held else 2.0)
    var center := Vector2(32, 56)
    var color := _suit_color()
    match int(card["suit"]):
        0:
            draw_colored_polygon(
                PackedVector2Array([center + Vector2(0, -15), center + Vector2(-12, 5), center + Vector2(12, 5)]),
                color
            )
            draw_circle(center + Vector2(-6, 4), 6, color)
            draw_circle(center + Vector2(6, 4), 6, color)
            draw_rect(Rect2(center + Vector2(-2, 6), Vector2(4, 11)), color)
        1:
            draw_circle(center + Vector2(-6.5, -5), 6.8, color)
            draw_circle(center + Vector2(6.5, -5), 6.8, color)
            draw_colored_polygon(
                PackedVector2Array([center + Vector2(-12.6, -2), center + Vector2(12.6, -2), center + Vector2(0, 15)]),
                color
            )
        2:
            draw_colored_polygon(
                PackedVector2Array([
                    center + Vector2(0, -15), center + Vector2(11, 0),
                    center + Vector2(0, 15), center + Vector2(-11, 0),
                ]),
                color
            )
        3:
            draw_circle(center + Vector2(0, -8), 6.6, color)
            draw_circle(center + Vector2(-7, 3), 6.6, color)
            draw_circle(center + Vector2(7, 3), 6.6, color)
            draw_rect(Rect2(center + Vector2(-2, 5), Vector2(4, 12)), color)
    if held:
        var tag := Color(0.95, 0.78, 0.3)
        draw_rect(Rect2(Vector2(0, 78), Vector2(64, 14)), tag)

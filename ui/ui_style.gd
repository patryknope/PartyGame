class_name UiStyle

# Central visual language of the prototype: casino palette,
# rounded styleboxes and the shared UI theme.

const GOLD := Color(0.95, 0.78, 0.3)
const GOLD_DARK := Color(0.72, 0.55, 0.16)
const FELT := Color(0.06, 0.17, 0.11)
const FELT_LIGHT := Color(0.1, 0.24, 0.155)
const INK := Color(0.09, 0.09, 0.13)
const CARD := Color(0.12, 0.14, 0.19, 0.98)
const CREAM := Color(0.97, 0.94, 0.86)
const FONT_PATH := "res://Assets/fonts/Fredoka.ttf"


static func flat(
    bg: Color,
    radius := 12,
    border := 0,
    border_color := Color.TRANSPARENT,
    shadow := 0,
) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = bg
    style.set_corner_radius_all(radius)
    if border > 0:
        style.set_border_width_all(border)
        style.border_color = border_color
    if shadow > 0:
        style.shadow_color = Color(0, 0, 0, 0.45)
        style.shadow_size = shadow
        style.shadow_offset = Vector2(0, 3)
    return style


static func circle(bg: Color, border := 0, border_color := Color.TRANSPARENT, shadow := 0) -> StyleBoxFlat:
    return flat(bg, 999, border, border_color, shadow)


static func build_theme() -> Theme:
    var theme := Theme.new()
    if ResourceLoader.exists(FONT_PATH):
        theme.default_font = load(FONT_PATH)
    theme.default_font_size = 19

    for type in ["Button", "OptionButton"]:
        var normal := flat(GOLD, 10, 0, Color.TRANSPARENT, 4)
        normal.set_content_margin_all(10)
        var hover := flat(GOLD.lightened(0.18), 10, 0, Color.TRANSPARENT, 6)
        hover.set_content_margin_all(10)
        var pressed := flat(GOLD_DARK, 10)
        pressed.set_content_margin_all(10)
        theme.set_stylebox("normal", type, normal)
        theme.set_stylebox("hover", type, hover)
        theme.set_stylebox("pressed", type, pressed)
        theme.set_stylebox("focus", type, StyleBoxEmpty.new())
        theme.set_color("font_color", type, INK)
        theme.set_color("font_hover_color", type, INK)
        theme.set_color("font_pressed_color", type, INK)
        theme.set_color("font_focus_color", type, INK)
        theme.set_font_size("font_size", type, 20)

    var panel := flat(CARD, 18, 2, GOLD, 12)
    panel.set_content_margin_all(30)
    theme.set_stylebox("panel", "PanelContainer", panel)
    return theme


static func title_look(label: Label, size: int, color := CREAM) -> void:
    label.add_theme_font_size_override("font_size", size)
    label.add_theme_color_override("font_color", color)
    label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.55))
    label.add_theme_constant_override("outline_size", int(size / 5.0))

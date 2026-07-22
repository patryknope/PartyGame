extends Control

# Main menu: player count + match length, then hands off to GameManager.

const ROUND_OPTIONS: Array[int] = [10, 15, 20, 30]

var players_option: OptionButton
var rounds_option: OptionButton


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var dim := ColorRect.new()
    dim.color = Color(0, 0, 0, 0.22)
    dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(dim)

    var title := Label.new()
    title.text = "PartyGame"
    UiStyle.title_look(title, 76, UiStyle.GOLD)
    title.position = Vector2(0, 88)
    title.size = Vector2(1280, 100)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(title)

    var subtitle := Label.new()
    subtitle.text = "Prototyp Etapu 1 — plansza Casino"
    UiStyle.title_look(subtitle, 21, UiStyle.CREAM)
    subtitle.position = Vector2(0, 192)
    subtitle.size = Vector2(1280, 30)
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(subtitle)

    var card := PanelContainer.new()
    card.position = Vector2(440, 270)
    card.custom_minimum_size = Vector2(400, 0)
    add_child(card)

    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation", 16)
    card.add_child(box)

    var players_label := Label.new()
    players_label.text = "Liczba graczy (hotseat)"
    players_label.add_theme_color_override("font_color", UiStyle.CREAM)
    box.add_child(players_label)

    players_option = OptionButton.new()
    for count in [2, 3, 4]:
        players_option.add_item("%d graczy" % count, count)
    players_option.select(0)
    box.add_child(players_option)

    var rounds_label := Label.new()
    rounds_label.text = "Dlugosc meczu"
    rounds_label.add_theme_color_override("font_color", UiStyle.CREAM)
    box.add_child(rounds_label)

    rounds_option = OptionButton.new()
    for rounds in ROUND_OPTIONS:
        rounds_option.add_item("%d rund" % rounds, rounds)
    rounds_option.select(1)
    box.add_child(rounds_option)

    var spacer := Control.new()
    spacer.custom_minimum_size = Vector2(0, 6)
    box.add_child(spacer)

    var start_button := Button.new()
    start_button.text = "Start!"
    start_button.custom_minimum_size = Vector2(0, 54)
    start_button.pressed.connect(_on_start_pressed)
    box.add_child(start_button)

    var controls := Label.new()
    controls.text = "Sterowanie w minigrze:  G1 WASD    G2 strzalki    G3 TFGH    G4 IJKL"
    controls.add_theme_font_size_override("font_size", 16)
    controls.add_theme_color_override("font_color", Color(1, 1, 1, 0.65))
    controls.position = Vector2(0, 668)
    controls.size = Vector2(1280, 24)
    controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(controls)


func _on_start_pressed() -> void:
    GameManager.start_match(
        players_option.get_selected_id(),
        rounds_option.get_selected_id()
    )

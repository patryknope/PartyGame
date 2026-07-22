extends Control

# Main menu: player count + match length, then hands off to GameManager.

const ROUND_OPTIONS: Array[int] = [10, 15, 20, 30]

var players_option: OptionButton
var rounds_option: OptionButton


func _ready() -> void:
    for i in 14:
        var glow := Panel.new()
        var color := UiStyle.GOLD if i % 3 == 0 else UiStyle.FELT_LIGHT.lightened(0.1)
        glow.add_theme_stylebox_override("panel", UiStyle.circle(Color(color.r, color.g, color.b, 0.1)))
        var diameter := 60.0 + (i * 37) % 160
        glow.size = Vector2(diameter, diameter)
        glow.position = Vector2((i * 331) % 1220, (i * 197) % 660)
        add_child(glow)

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

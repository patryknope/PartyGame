extends Control

# Main menu: player count + match length, then hands off to GameManager.

const ROUND_OPTIONS: Array[int] = [10, 15, 20, 30]

var players_option: OptionButton
var rounds_option: OptionButton


func _ready() -> void:
    var title := Label.new()
    title.text = "PartyGame"
    title.add_theme_font_size_override("font_size", 64)
    title.position = Vector2(0, 120)
    title.size = Vector2(1280, 90)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(title)

    var subtitle := Label.new()
    subtitle.text = "Prototyp Etapu 1 — plansza Casino"
    subtitle.add_theme_font_size_override("font_size", 20)
    subtitle.position = Vector2(0, 210)
    subtitle.size = Vector2(1280, 30)
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(subtitle)

    var players_label := Label.new()
    players_label.text = "Liczba graczy (hotseat):"
    players_label.position = Vector2(490, 300)
    add_child(players_label)

    players_option = OptionButton.new()
    for count in [2, 3, 4]:
        players_option.add_item("%d graczy" % count, count)
    players_option.select(0)
    players_option.position = Vector2(690, 292)
    players_option.size = Vector2(140, 36)
    add_child(players_option)

    var rounds_label := Label.new()
    rounds_label.text = "Dlugosc meczu (rund):"
    rounds_label.position = Vector2(490, 360)
    add_child(rounds_label)

    rounds_option = OptionButton.new()
    for rounds in ROUND_OPTIONS:
        rounds_option.add_item("%d rund" % rounds, rounds)
    rounds_option.select(1)
    rounds_option.position = Vector2(690, 352)
    rounds_option.size = Vector2(140, 36)
    add_child(rounds_option)

    var controls := Label.new()
    controls.text = "Sterowanie w minigrze:  G1 WASD   G2 strzalki   G3 TFGH   G4 IJKL"
    controls.add_theme_font_size_override("font_size", 16)
    controls.position = Vector2(0, 430)
    controls.size = Vector2(1280, 24)
    controls.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(controls)

    var start_button := Button.new()
    start_button.text = "Start"
    start_button.position = Vector2(540, 500)
    start_button.size = Vector2(200, 56)
    start_button.pressed.connect(_on_start_pressed)
    add_child(start_button)


func _on_start_pressed() -> void:
    GameManager.start_match(
        players_option.get_selected_id(),
        rounds_option.get_selected_id()
    )

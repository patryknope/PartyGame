extends Control

# Minigame: Poker Draw (FFA, 2-4 players hotseat).
# Each player in turn gets 5 cards and one redraw. Best hand wins.

var order: Array = []
var current_index := 0
var results := {}

var banner_label: Label
var cards_row: HBoxContainer
var card_nodes: Array = []
var redraw_button: Button
var result_label: Label
var summary_label: Label

var _deck: Array = []
var _hand: Array = []


func _ready() -> void:
    var background := Scenery.new()
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    var table := Panel.new()
    table.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.09, 0.32, 0.18), 30, 8, Color(0.35, 0.22, 0.12), 12)
    )
    table.position = Vector2(240, 140)
    table.size = Vector2(800, 460)
    add_child(table)

    var banner := Panel.new()
    banner.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.12, 0.14, 0.19, 0.97), 16, 3, UiStyle.GOLD, 8)
    )
    banner.position = Vector2(340, 24)
    banner.size = Vector2(600, 70)
    add_child(banner)

    banner_label = Label.new()
    banner_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    banner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    banner_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    UiStyle.title_look(banner_label, 26, UiStyle.GOLD)
    banner.add_child(banner_label)

    var hint := Label.new()
    hint.text = "Kliknij karty, ktore chcesz zatrzymac, potem wymien."
    hint.position = Vector2(240, 200)
    hint.size = Vector2(800, 26)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(hint, 18, UiStyle.CREAM)
    add_child(hint)

    cards_row = HBoxContainer.new()
    cards_row.position = Vector2(430, 260)
    cards_row.add_theme_constant_override("separation", 22)
    add_child(cards_row)

    redraw_button = Button.new()
    redraw_button.text = "Wymien i sprawdz!"
    redraw_button.position = Vector2(510, 400)
    redraw_button.size = Vector2(260, 52)
    redraw_button.pressed.connect(_on_redraw_pressed)
    add_child(redraw_button)

    result_label = Label.new()
    result_label.position = Vector2(240, 470)
    result_label.size = Vector2(800, 40)
    result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(result_label, 26, Color.WHITE)
    add_child(result_label)

    summary_label = Label.new()
    summary_label.position = Vector2(240, 528)
    summary_label.size = Vector2(800, 60)
    summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(summary_label, 17, UiStyle.CREAM)
    add_child(summary_label)

    order = PlayerManager.get_player_ids()
    _start_player()


func _start_player() -> void:
    var player := PlayerManager.get_player(order[current_index])
    banner_label.text = "Poker Draw — gra: %s" % player["name"]
    banner_label.add_theme_color_override("font_color", player["color"])
    result_label.text = ""
    _deck = PlayingCards.new_deck()
    _hand = []
    for i in 5:
        _hand.append(_deck.pop_back())
    for node in card_nodes:
        node.queue_free()
    card_nodes.clear()
    for i in 5:
        var card_node := CardNode.new()
        card_node.card = _hand[i]
        card_node.index = i
        cards_row.add_child(card_node)
        card_nodes.append(card_node)
    redraw_button.visible = true


func _on_redraw_pressed() -> void:
    redraw_button.visible = false
    for i in 5:
        if not card_nodes[i].held:
            _hand[i] = _deck.pop_back()
            card_nodes[i].card = _hand[i]
            card_nodes[i].held = false
            card_nodes[i].refresh()
        card_nodes[i].selectable = false
    var evaluation := PlayingCards.evaluate(_hand)
    var player_id: int = order[current_index]
    results[player_id] = evaluation
    result_label.text = "%s: %s" % [PlayerManager.get_player(player_id)["name"], evaluation["name"]]
    _refresh_summary()
    await get_tree().create_timer(1.6).timeout
    current_index += 1
    if current_index < order.size():
        _start_player()
    else:
        _finish()


func _refresh_summary() -> void:
    var parts: Array[String] = []
    for player_id in results:
        parts.append("%s: %s" % [
            PlayerManager.get_player(player_id)["name"], results[player_id]["name"],
        ])
    summary_label.text = "    ".join(parts)


func _finish() -> void:
    var ranking: Array = results.keys()
    ranking.sort_custom(
        func(a, b): return PlayingCards.compare_scores(results[a]["score"], results[b]["score"]) > 0
    )
    var winner := PlayerManager.get_player(ranking[0])
    banner_label.text = "Wygrywa: %s (%s)!" % [winner["name"], results[ranking[0]]["name"]]
    banner_label.add_theme_color_override("font_color", UiStyle.GOLD)
    await get_tree().create_timer(1.6).timeout
    MinigameManager.report_finished(ranking)

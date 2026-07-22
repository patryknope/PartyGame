extends Control

# HUD displays state and forwards button presses to managers.
# It contains no game logic (GDD coding rule 3).

var round_label: Label
var status_label: Label
var roll_button: Button
var end_turn_button: Button
var route_box: HBoxContainer
var dice_panel: Panel
var dice_label: Label
var player_cards := {}
var coin_labels := {}

var _dice_anim_id := 0


func _ready() -> void:
    _build()
    GameManager.round_started.connect(_on_round_started)
    GameManager.dice_rolled.connect(_on_dice_rolled)
    TurnManager.turn_started.connect(_on_turn_started)
    BoardManager.route_choice_required.connect(_on_route_choice_required)
    BoardManager.move_finished.connect(_on_move_finished)
    BoardManager.tile_resolved.connect(_on_tile_resolved)
    BoardManager.start_passed.connect(_on_start_passed)
    EconomyManager.coins_changed.connect(_on_coins_changed)


func _build() -> void:
    var round_badge := Panel.new()
    round_badge.add_theme_stylebox_override("panel", UiStyle.flat(UiStyle.GOLD, 12, 0, Color.TRANSPARENT, 5))
    round_badge.position = Vector2(1080, 14)
    round_badge.size = Vector2(184, 44)
    add_child(round_badge)

    round_label = Label.new()
    round_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    round_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    round_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    round_label.add_theme_font_size_override("font_size", 21)
    round_label.add_theme_color_override("font_color", UiStyle.INK)
    round_badge.add_child(round_label)

    var action_bar := Panel.new()
    action_bar.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.07, 0.08, 0.11, 0.92), 16, 2, UiStyle.GOLD_DARK, 8)
    )
    action_bar.position = Vector2(300, 606)
    action_bar.size = Vector2(680, 100)
    add_child(action_bar)

    dice_panel = Panel.new()
    dice_panel.add_theme_stylebox_override(
        "panel", UiStyle.flat(UiStyle.CREAM, 14, 3, UiStyle.GOLD_DARK, 5)
    )
    dice_panel.position = Vector2(18, 18)
    dice_panel.size = Vector2(64, 64)
    dice_panel.visible = false
    action_bar.add_child(dice_panel)

    dice_label = Label.new()
    dice_label.set_anchors_preset(Control.PRESET_FULL_RECT)
    dice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dice_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    dice_label.add_theme_font_size_override("font_size", 34)
    dice_label.add_theme_color_override("font_color", UiStyle.INK)
    dice_panel.add_child(dice_label)

    status_label = Label.new()
    status_label.position = Vector2(96, 8)
    status_label.size = Vector2(488, 34)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 20)
    status_label.add_theme_color_override("font_color", UiStyle.CREAM)
    action_bar.add_child(status_label)

    roll_button = Button.new()
    roll_button.text = "Rzuc koscia!"
    roll_button.position = Vector2(240, 46)
    roll_button.size = Vector2(200, 44)
    roll_button.visible = false
    roll_button.pressed.connect(func(): GameManager.roll_dice())
    action_bar.add_child(roll_button)

    end_turn_button = Button.new()
    end_turn_button.text = "Zakoncz ture"
    end_turn_button.position = Vector2(240, 46)
    end_turn_button.size = Vector2(200, 44)
    end_turn_button.visible = false
    end_turn_button.pressed.connect(_on_end_turn_pressed)
    action_bar.add_child(end_turn_button)

    route_box = HBoxContainer.new()
    route_box.position = Vector2(140, 46)
    route_box.add_theme_constant_override("separation", 20)
    route_box.visible = false
    action_bar.add_child(route_box)


func setup_players() -> void:
    for card in player_cards.values():
        card.queue_free()
    player_cards.clear()
    coin_labels.clear()
    for player in PlayerManager.players:
        var card := Panel.new()
        card.position = Vector2(16 + 172 * player["id"], 12)
        card.size = Vector2(160, 62)
        add_child(card)
        player_cards[player["id"]] = card

        var chip := Panel.new()
        chip.add_theme_stylebox_override(
            "panel", UiStyle.circle(player["color"], 2, Color(1, 1, 1, 0.85))
        )
        chip.position = Vector2(10, 17)
        chip.size = Vector2(28, 28)
        card.add_child(chip)

        var name_label := Label.new()
        name_label.text = player["name"]
        name_label.position = Vector2(48, 6)
        name_label.add_theme_font_size_override("font_size", 17)
        name_label.add_theme_color_override("font_color", UiStyle.CREAM)
        card.add_child(name_label)

        var coins_label := Label.new()
        coins_label.text = "0"
        coins_label.position = Vector2(48, 30)
        coins_label.add_theme_font_size_override("font_size", 17)
        coins_label.add_theme_color_override("font_color", UiStyle.GOLD)
        card.add_child(coins_label)
        coin_labels[player["id"]] = coins_label
    _highlight_card(-1)


func _highlight_card(active_id: int) -> void:
    for pid in player_cards:
        var active: bool = pid == active_id
        var border := UiStyle.GOLD if active else Color(1, 1, 1, 0.14)
        player_cards[pid].add_theme_stylebox_override(
            "panel", UiStyle.flat(UiStyle.CARD, 14, 3 if active else 2, border, 6 if active else 3)
        )
        player_cards[pid].modulate = Color(1, 1, 1) if active or active_id == -1 else Color(0.72, 0.72, 0.72)


func _on_round_started(round_number: int) -> void:
    round_label.text = "Runda %d / %d" % [round_number, GameManager.total_rounds]


func _on_turn_started(player_id: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "Tura gracza: %s" % player["name"]
    roll_button.visible = true
    end_turn_button.visible = false
    route_box.visible = false
    dice_panel.visible = false
    _highlight_card(player_id)


func _on_dice_rolled(player_id: int, result: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s rzuca..." % player["name"]
    roll_button.visible = false
    dice_panel.visible = true
    _animate_dice(player["name"], result)


func _animate_dice(player_name: String, result: int) -> void:
    _dice_anim_id += 1
    var anim_id := _dice_anim_id
    for i in 9:
        if anim_id != _dice_anim_id or not is_inside_tree():
            return
        dice_label.text = str(1 + randi() % 8)
        await get_tree().create_timer(0.05).timeout
    if anim_id != _dice_anim_id or not is_inside_tree():
        return
    dice_label.text = str(result)
    status_label.text = "%s wyrzucil: %d" % [player_name, result]


func _on_route_choice_required(_player_id: int, options: Array) -> void:
    for child in route_box.get_children():
        child.queue_free()
    for option in options:
        var tile: Dictionary = BoardManager.get_tile(option)
        var button := Button.new()
        button.text = "Skrot (ryzyko!)" if tile["ring"] < 0 else "Glowna trasa"
        button.custom_minimum_size = Vector2(180, 44)
        button.pressed.connect(_on_route_pressed.bind(option))
        route_box.add_child(button)
    route_box.visible = true
    status_label.text = "Wybierz trase"


func _on_route_pressed(tile_id: int) -> void:
    route_box.visible = false
    BoardManager.choose_route(tile_id)


func _on_move_finished(_player_id: int) -> void:
    end_turn_button.visible = true


func _on_tile_resolved(player_id: int, _tile_id: int, tile_type: String, coins_delta: int) -> void:
    var player := PlayerManager.get_player(player_id)
    if coins_delta > 0:
        status_label.text = "%s: +%d monet!" % [player["name"], coins_delta]
    elif coins_delta < 0:
        status_label.text = "%s: %d monet" % [player["name"], coins_delta]
    else:
        status_label.text = "%s: spokojne pole (%s)" % [player["name"], tile_type]


func _on_start_passed(player_id: int, bonus: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s mija START: +%d monet!" % [player["name"], bonus]


func _on_end_turn_pressed() -> void:
    end_turn_button.visible = false
    GameManager.end_turn()


func _on_coins_changed(player_id: int, coins: int) -> void:
    if coin_labels.has(player_id):
        coin_labels[player_id].text = str(coins)

extends Control

# HUD displays state and forwards button presses to managers.
# It contains no game logic (GDD coding rule 3).

var round_label: Label
var status_label: Label
var roll_button: Button
var end_turn_button: Button
var route_box: HBoxContainer
var player_panels := {}
var coin_labels := {}


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
    round_label = Label.new()
    round_label.position = Vector2(1080, 16)
    round_label.add_theme_font_size_override("font_size", 22)
    add_child(round_label)

    status_label = Label.new()
    status_label.position = Vector2(420, 640)
    status_label.size = Vector2(440, 60)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 20)
    add_child(status_label)

    roll_button = Button.new()
    roll_button.text = "Rzuc koscia (1-8)"
    roll_button.position = Vector2(540, 590)
    roll_button.size = Vector2(200, 44)
    roll_button.visible = false
    roll_button.pressed.connect(func(): GameManager.roll_dice())
    add_child(roll_button)

    end_turn_button = Button.new()
    end_turn_button.text = "Zakoncz ture"
    end_turn_button.position = Vector2(540, 590)
    end_turn_button.size = Vector2(200, 44)
    end_turn_button.visible = false
    end_turn_button.pressed.connect(_on_end_turn_pressed)
    add_child(end_turn_button)

    route_box = HBoxContainer.new()
    route_box.position = Vector2(470, 590)
    route_box.add_theme_constant_override("separation", 16)
    route_box.visible = false
    add_child(route_box)


func setup_players() -> void:
    for panel in player_panels.values():
        panel.queue_free()
    player_panels.clear()
    coin_labels.clear()
    for player in PlayerManager.players:
        var panel := PanelContainer.new()
        var box := VBoxContainer.new()
        var name_label := Label.new()
        name_label.text = player["name"]
        name_label.add_theme_color_override("font_color", player["color"])
        name_label.add_theme_font_size_override("font_size", 18)
        var coins_label := Label.new()
        coins_label.add_theme_font_size_override("font_size", 16)
        coins_label.text = "0 monet"
        coin_labels[player["id"]] = coins_label
        box.add_child(name_label)
        box.add_child(coins_label)
        panel.add_child(box)
        panel.position = Vector2(16 + 150 * player["id"], 12)
        panel.custom_minimum_size = Vector2(140, 0)
        add_child(panel)
        player_panels[player["id"]] = panel


func _on_round_started(round_number: int) -> void:
    round_label.text = "Runda %d / %d" % [round_number, GameManager.total_rounds]


func _on_turn_started(player_id: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "Tura gracza: %s" % player["name"]
    roll_button.visible = true
    end_turn_button.visible = false
    route_box.visible = false
    for pid in player_panels:
        player_panels[pid].modulate = Color(1, 1, 1) if pid == player_id else Color(0.55, 0.55, 0.55)


func _on_dice_rolled(player_id: int, result: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s wyrzucil: %d" % [player["name"], result]
    roll_button.visible = false


func _on_route_choice_required(_player_id: int, options: Array) -> void:
    for child in route_box.get_children():
        child.queue_free()
    for option in options:
        var tile: Dictionary = BoardManager.get_tile(option)
        var button := Button.new()
        button.text = "Skrot (ryzyko!)" if tile["ring"] < 0 else "Glowna trasa"
        button.custom_minimum_size = Vector2(160, 44)
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
        status_label.text = "%s: nic sie nie dzieje (%s)" % [player["name"], tile_type]


func _on_start_passed(player_id: int, bonus: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s mija START: +%d monet!" % [player["name"], bonus]


func _on_end_turn_pressed() -> void:
    end_turn_button.visible = false
    GameManager.end_turn()


func _on_coins_changed(player_id: int, coins: int) -> void:
    if coin_labels.has(player_id):
        coin_labels[player_id].text = "%d monet" % coins

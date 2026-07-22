extends Control

# HUD displays state and forwards button presses to managers.
# It contains no game logic (GDD coding rule 3).

var round_label: Label
var status_label: Label
var dice_box: HBoxContainer
var end_turn_button: Button
var route_box: HBoxContainer
var trophy_box: HBoxContainer
var dice_panel: Panel
var dice_label: Label
var items_button: Button
var side_panel: Panel
var side_box: VBoxContainer
var player_cards := {}
var coin_labels := {}
var trophy_labels := {}

var _dice_anim_id := 0
var _items_open := false


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
    TrophyManager.trophy_offer.connect(_on_trophy_offer)
    TrophyManager.trophy_bought.connect(_on_trophy_bought)
    TrophyManager.trophies_changed.connect(_on_trophies_changed)
    ItemManager.inventory_changed.connect(_on_inventory_changed)
    ItemManager.shop_opened.connect(_on_shop_opened)
    ItemManager.trap_triggered.connect(_on_trap_status)
    ItemManager.item_used.connect(_on_item_used_status)
    ItemManager.item_blocked.connect(_on_item_blocked_status)
    BuildingManager.build_offer.connect(_on_build_offer)
    BuildingManager.upgrade_offer.connect(_on_upgrade_offer)
    BuildingManager.income_granted.connect(_on_income_status)
    CasinoManager.poker_started.connect(_on_poker_started)
    CasinoManager.poker_finished.connect(_on_poker_finished)
    GameManager.jackpot_result.connect(_on_jackpot_status)


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
    status_label.size = Vector2(406, 34)
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status_label.add_theme_font_size_override("font_size", 20)
    status_label.add_theme_color_override("font_color", UiStyle.CREAM)
    action_bar.add_child(status_label)

    dice_box = HBoxContainer.new()
    dice_box.position = Vector2(20, 46)
    dice_box.add_theme_constant_override("separation", 8)
    dice_box.visible = false
    for i in Dice.TYPES.size():
        var dice_button := Button.new()
        dice_button.text = Dice.TYPES[i]["name"]
        dice_button.custom_minimum_size = Vector2(122, 44)
        dice_button.add_theme_font_size_override("font_size", 14)
        dice_button.pressed.connect(_on_dice_pressed.bind(i))
        dice_box.add_child(dice_button)
    action_bar.add_child(dice_box)

    trophy_box = HBoxContainer.new()
    trophy_box.position = Vector2(140, 46)
    trophy_box.add_theme_constant_override("separation", 20)
    trophy_box.visible = false
    var buy_button := Button.new()
    buy_button.text = "Kup trofeum (%d)" % TrophyManager.TROPHY_COST
    buy_button.custom_minimum_size = Vector2(190, 44)
    buy_button.pressed.connect(_on_trophy_buy_pressed)
    trophy_box.add_child(buy_button)
    var skip_button := Button.new()
    skip_button.text = "Nie kupuj"
    skip_button.custom_minimum_size = Vector2(150, 44)
    skip_button.pressed.connect(_on_trophy_skip_pressed)
    trophy_box.add_child(skip_button)
    action_bar.add_child(trophy_box)

    items_button = Button.new()
    items_button.text = "Przedmioty (0)"
    items_button.position = Vector2(512, 10)
    items_button.size = Vector2(150, 32)
    items_button.visible = false
    items_button.pressed.connect(_on_items_button_pressed)
    action_bar.add_child(items_button)

    side_panel = Panel.new()
    side_panel.add_theme_stylebox_override(
        "panel", UiStyle.flat(Color(0.09, 0.1, 0.14, 0.96), 16, 2, UiStyle.GOLD_DARK, 8)
    )
    side_panel.position = Vector2(966, 84)
    side_panel.size = Vector2(300, 500)
    side_panel.visible = false
    add_child(side_panel)

    var scroll := ScrollContainer.new()
    scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
    scroll.offset_left = 12
    scroll.offset_top = 12
    scroll.offset_right = -12
    scroll.offset_bottom = -12
    side_panel.add_child(scroll)

    side_box = VBoxContainer.new()
    side_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    side_box.add_theme_constant_override("separation", 10)
    scroll.add_child(side_box)

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
    trophy_labels.clear()
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
        coins_label.text = str(EconomyManager.get_coins(player["id"]))
        coins_label.position = Vector2(48, 30)
        coins_label.add_theme_font_size_override("font_size", 17)
        coins_label.add_theme_color_override("font_color", UiStyle.GOLD)
        card.add_child(coins_label)
        coin_labels[player["id"]] = coins_label

        var trophy_label := Label.new()
        trophy_label.text = "★ 0"
        trophy_label.position = Vector2(104, 30)
        trophy_label.add_theme_font_size_override("font_size", 17)
        trophy_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.92))
        card.add_child(trophy_label)
        trophy_labels[player["id"]] = trophy_label
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
    var mine := GameManager.local_can_act(player_id)
    if mine:
        status_label.text = "Tura gracza: %s — wybierz kosc" % player["name"]
    else:
        status_label.text = "Tura gracza: %s..." % player["name"]
    dice_box.visible = mine
    end_turn_button.visible = false
    route_box.visible = false
    trophy_box.visible = false
    dice_panel.visible = false
    items_button.visible = mine
    if mine:
        _refresh_items_button(player_id)
    _close_side_panel()
    _highlight_card(player_id)


func _on_dice_pressed(dice_index: int) -> void:
    dice_box.visible = false
    items_button.visible = false
    _close_side_panel()
    GameManager.request_roll(dice_index)


func _on_dice_rolled(player_id: int, result: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s rzuca..." % player["name"]
    dice_box.visible = false
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
    if result == 0:
        status_label.text = "%s wyrzucil: 0 — stoi w miejscu!" % player_name
    else:
        status_label.text = "%s wyrzucil: %d" % [player_name, result]


func _on_route_choice_required(player_id: int, options: Array) -> void:
    if not GameManager.local_can_act(player_id):
        status_label.text = "%s wybiera trase..." % PlayerManager.get_player(player_id)["name"]
        return
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
    GameManager.request_route(tile_id)


func _on_move_finished(player_id: int) -> void:
    end_turn_button.visible = GameManager.local_can_act(player_id)


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
    GameManager.request_end_turn()


func _on_coins_changed(player_id: int, coins: int) -> void:
    if coin_labels.has(player_id):
        coin_labels[player_id].text = str(coins)


func _on_trophy_offer(player_id: int, cost: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s: kupic trofeum za %d monet?" % [player["name"], cost]
    trophy_box.visible = GameManager.local_can_act(player_id)


func _on_trophy_buy_pressed() -> void:
    trophy_box.visible = false
    GameManager.request_trophy(true)


func _on_trophy_skip_pressed() -> void:
    trophy_box.visible = false
    GameManager.request_trophy(false)


func _on_trophy_bought(player_id: int, count: int) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s zdobywa trofeum! (ma %d)" % [player["name"], count]


func _on_trophies_changed(player_id: int, count: int) -> void:
    if trophy_labels.has(player_id):
        trophy_labels[player_id].text = "★ %d" % count


# ── Side panel (items / shop / buildings) ─────────────────────────

func _open_side_panel(title: String) -> void:
    for child in side_box.get_children():
        child.queue_free()
    var title_label := Label.new()
    title_label.text = title
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(title_label, 22, UiStyle.GOLD)
    side_box.add_child(title_label)
    side_panel.visible = true


func _close_side_panel() -> void:
    side_panel.visible = false
    _items_open = false


func _side_button(text: String, action: Callable, enabled := true) -> void:
    var button := Button.new()
    button.text = text
    button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    button.custom_minimum_size = Vector2(260, 0)
    button.disabled = not enabled
    button.add_theme_font_size_override("font_size", 15)
    button.pressed.connect(action)
    side_box.add_child(button)


func _refresh_items_button(player_id: int) -> void:
    items_button.text = "Przedmioty (%d)" % ItemManager.get_items(player_id).size()


func _on_inventory_changed(player_id: int, _items: Array) -> void:
    if GameManager.state != GameManager.State.PLAYER_TURN:
        return
    if player_id == TurnManager.current_player_id():
        _refresh_items_button(player_id)


func _on_items_button_pressed() -> void:
    if _items_open:
        _close_side_panel()
        return
    var player_id := TurnManager.current_player_id()
    var items := ItemManager.get_items(player_id)
    _open_side_panel("Przedmioty")
    _items_open = true
    if items.is_empty():
        var empty_label := Label.new()
        empty_label.text = "Pusto! Odwiedz SKLEP."
        empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        side_box.add_child(empty_label)
    for item_id in items:
        if NetworkManager.is_online and item_id in ["extra_roll", "loaded_dice"]:
            continue
        var item := ItemManager.get_definition(item_id)
        _side_button(
            "%s\n%s" % [item["name"], item["desc"]],
            _on_use_item_pressed.bind(String(item_id)),
        )
    _side_button("Zamknij", _close_side_panel)


func _on_use_item_pressed(item_id: String) -> void:
    var player_id := TurnManager.current_player_id()
    match item_id:
        "rocket", "magnet", "swap":
            _open_side_panel("Wybierz cel")
            for player in PlayerManager.players:
                if player["id"] == player_id:
                    continue
                _side_button(
                    player["name"],
                    _on_target_pressed.bind(item_id, int(player["id"])),
                )
            _side_button("Anuluj", _close_side_panel)
        "extra_roll":
            ItemManager.use_item(player_id, item_id)
            var results := GameManager.roll_pair()
            _open_side_panel("Extra Roll")
            _side_button("Wynik: %d" % results[0], _on_forced_move_pressed.bind(int(results[0])))
            _side_button("Wynik: %d" % results[1], _on_forced_move_pressed.bind(int(results[1])))
        "loaded_dice":
            ItemManager.use_item(player_id, item_id)
            _open_side_panel("Loaded Dice")
            for steps in range(1, 11):
                _side_button("Ruch: %d" % steps, _on_forced_move_pressed.bind(steps))
        _:
            GameManager.request_item_use(player_id, item_id)
            _close_side_panel()


func _on_target_pressed(item_id: String, target_id: int) -> void:
    GameManager.request_item_use(TurnManager.current_player_id(), item_id, target_id)
    _close_side_panel()


func _on_forced_move_pressed(steps: int) -> void:
    _close_side_panel()
    dice_box.visible = false
    items_button.visible = false
    GameManager.move_forced(steps)


func _on_shop_opened(player_id: int, offers: Array) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s wchodzi do sklepu" % player["name"]
    if not GameManager.local_can_act(player_id):
        return
    _open_side_panel("Sklep")
    for item in offers:
        _side_button(
            "%s (%d monet)\n%s" % [item["name"], item["price"], item["desc"]],
            _on_shop_buy_pressed.bind(int(player_id), String(item["id"])),
            EconomyManager.get_coins(player_id) >= int(item["price"]),
        )
    _side_button("Nic nie kupuje", _close_side_panel)


func _on_shop_buy_pressed(player_id: int, item_id: String) -> void:
    GameManager.request_shop_buy(player_id, item_id)
    _close_side_panel()


func _on_build_offer(player_id: int, _tile_id: int, cost: int) -> void:
    status_label.text = "%s moze postawic budynek" % PlayerManager.get_player(player_id)["name"]
    if not GameManager.local_can_act(player_id):
        return
    _open_side_panel("Wolna dzialka!")
    _side_button(
        "Postaw budynek ekonomiczny (%d monet)\n+%d monet co ture za poziom" % [
            cost, BuildingManager.INCOME_PER_LEVEL,
        ],
        _on_building_confirm_pressed,
    )
    _side_button("Nie teraz", _on_building_skip_pressed)


func _on_upgrade_offer(player_id: int, _tile_id: int, cost: int, next_level: int) -> void:
    status_label.text = "%s moze ulepszyc budynek" % PlayerManager.get_player(player_id)["name"]
    if not GameManager.local_can_act(player_id):
        return
    _open_side_panel("Budowniczy")
    _side_button(
        "Ulepsz do poziomu %d (%d monet)" % [next_level, cost],
        _on_building_confirm_pressed,
    )
    _side_button("Nie teraz", _on_building_skip_pressed)


func _on_building_confirm_pressed() -> void:
    GameManager.request_building(true)
    _close_side_panel()


func _on_building_skip_pressed() -> void:
    GameManager.request_building(false)
    _close_side_panel()


func _on_trap_status(victim_id: int, owner_id: int, coins_lost: int) -> void:
    status_label.text = "Pulapka gracza %s! %s traci %d monet" % [
        PlayerManager.get_player(owner_id)["name"],
        PlayerManager.get_player(victim_id)["name"],
        coins_lost,
    ]


func _on_item_used_status(player_id: int, item_id: String, target_id: int) -> void:
    var item := ItemManager.get_definition(item_id)
    var text := "%s uzywa: %s" % [PlayerManager.get_player(player_id)["name"], item["name"]]
    if target_id >= 0:
        text += " na %s" % PlayerManager.get_player(target_id)["name"]
    status_label.text = text


func _on_item_blocked_status(target_id: int) -> void:
    status_label.text = "%s: tarcza blokuje atak!" % PlayerManager.get_player(target_id)["name"]


func _on_income_status(player_id: int, amount: int) -> void:
    status_label.text = "%s dostaje +%d monet z budynku" % [
        PlayerManager.get_player(player_id)["name"], amount,
    ]


func _on_poker_started(player_id: int, hand: Array) -> void:
    var player := PlayerManager.get_player(player_id)
    status_label.text = "%s siada do pokera!" % player["name"]
    if not GameManager.local_can_act(player_id):
        return
    _open_side_panel("Poker!")
    var hint := Label.new()
    hint.text = "Kliknij karty, ktore trzymasz."
    hint.add_theme_font_size_override("font_size", 14)
    hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    side_box.add_child(hint)
    var cards_row := HBoxContainer.new()
    cards_row.add_theme_constant_override("separation", -14)
    var card_nodes: Array = []
    for i in hand.size():
        var card_node := CardNode.new()
        card_node.card = hand[i]
        card_node.index = i
        cards_row.add_child(card_node)
        card_nodes.append(card_node)
    side_box.add_child(cards_row)
    _side_button("Wymien i sprawdz!", _on_poker_redraw_pressed.bind(card_nodes))


func _on_poker_redraw_pressed(card_nodes: Array) -> void:
    var held: Array = []
    for card_node in card_nodes:
        if card_node.held:
            held.append(card_node.index)
    _close_side_panel()
    GameManager.request_poker(held)


func _on_poker_finished(player_id: int, _hand: Array, hand_name: String, payout: int) -> void:
    var player := PlayerManager.get_player(player_id)
    if payout > 0:
        status_label.text = "%s: %s! Wygrywa %d monet" % [player["name"], hand_name, payout]
    else:
        status_label.text = "%s: %s — bez wygranej" % [player["name"], hand_name]


func _on_jackpot_status(player_id: int, kind: String, value: int) -> void:
    var player := PlayerManager.get_player(player_id)
    match kind:
        "jackpot":
            status_label.text = "%s krzyczy JACKPOT! +%d monet" % [player["name"], value]
        "extra_roll":
            status_label.text = "%s: JACKPOT — extra rzut: %d!" % [player["name"], value]
        "bust":
            status_label.text = "%s: BUST! -%d monet" % [player["name"], value]

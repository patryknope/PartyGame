extends Control

# Root scene: switches between menu, board, minigame and overlay screens.
# Pure orchestration + display — all game logic lives in the managers.

var menu: Control
var board_view: Control
var hud: Control
var overlay: Control
var current_minigame: Control


func _ready() -> void:
    randomize()
    theme = UiStyle.build_theme()

    var background := ColorRect.new()
    background.color = UiStyle.FELT
    background.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(background)

    board_view = preload("res://board/board_view.gd").new()
    board_view.set_anchors_preset(Control.PRESET_FULL_RECT)
    board_view.visible = false
    add_child(board_view)

    hud = preload("res://ui/hud.gd").new()
    hud.set_anchors_preset(Control.PRESET_FULL_RECT)
    hud.visible = false
    add_child(hud)

    menu = preload("res://ui/main_menu.gd").new()
    menu.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(menu)

    overlay = Control.new()
    overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
    overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(overlay)

    GameManager.state_changed.connect(_on_state_changed)
    GameManager.round_started.connect(_on_round_started)
    GameManager.minigame_rewards_granted.connect(_on_minigame_rewards)
    GameManager.match_ended.connect(_on_match_ended)

    if "autotest" in OS.get_cmdline_user_args():
        _setup_autotest()
    elif "screenshots" in OS.get_cmdline_user_args():
        _screenshot_run()


func _on_state_changed(new_state: int) -> void:
    match new_state:
        GameManager.State.MAIN_MENU:
            _clear_overlay()
            _free_minigame()
            menu.visible = true
            board_view.visible = false
            hud.visible = false
        GameManager.State.PLAYER_TURN:
            menu.visible = false
            board_view.visible = true
            hud.visible = true
        GameManager.State.MINIGAME:
            _show_minigame_intro()


func _on_round_started(round_number: int) -> void:
    if round_number == 1:
        board_view.setup_pawns()
        hud.setup_players()


func _show_minigame_intro() -> void:
    var info: Dictionary = MinigameManager.current
    var panel := _make_panel()
    _panel_title(panel, info["name"])
    _panel_text(panel, info["rules"])
    _panel_button(panel, "Start!", _start_minigame)


func _start_minigame() -> void:
    _clear_overlay()
    board_view.visible = false
    hud.visible = false
    current_minigame = MinigameManager.instantiate_current()
    current_minigame.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(current_minigame)


func _on_minigame_rewards(ranking: Array, rewards: Array) -> void:
    _free_minigame()
    board_view.visible = true
    hud.visible = true
    var panel := _make_panel()
    _panel_title(panel, "Wyniki minigry")
    var lines: Array[String] = []
    for i in ranking.size():
        var player := PlayerManager.get_player(ranking[i])
        lines.append("%d. %s   +%d monet" % [i + 1, player["name"], rewards[i]])
    _panel_text(panel, "\n".join(lines))
    _panel_button(panel, "Wroc na plansze", _on_results_confirmed)


func _on_results_confirmed() -> void:
    _clear_overlay()
    GameManager.continue_after_minigame()


func _on_match_ended(final_ranking: Array) -> void:
    var panel := _make_panel()
    _panel_title(panel, "Koniec meczu!")
    var lines: Array[String] = []
    for i in final_ranking.size():
        var player := PlayerManager.get_player(final_ranking[i])
        var trophies := TrophyManager.get_trophies(final_ranking[i])
        var coins := EconomyManager.get_coins(final_ranking[i])
        lines.append("%d. %s — ★ %d, %d monet" % [i + 1, player["name"], trophies, coins])
    _panel_text(panel, "\n".join(lines))
    _panel_button(panel, "Nowy mecz", func(): GameManager.return_to_menu())


func _free_minigame() -> void:
    if current_minigame != null:
        current_minigame.queue_free()
        current_minigame = null


func _clear_overlay() -> void:
    for child in overlay.get_children():
        child.queue_free()


func _make_panel() -> VBoxContainer:
    var dim := ColorRect.new()
    dim.color = Color(0, 0, 0, 0.55)
    dim.set_anchors_preset(Control.PRESET_FULL_RECT)
    dim.mouse_filter = Control.MOUSE_FILTER_STOP
    overlay.add_child(dim)

    var center := CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    overlay.add_child(center)

    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(540, 0)
    center.add_child(panel)

    var box := VBoxContainer.new()
    box.add_theme_constant_override("separation", 18)
    panel.add_child(box)
    return box


func _panel_title(box: VBoxContainer, text: String) -> void:
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(label, 34, UiStyle.GOLD)
    box.add_child(label)


func _panel_text(box: VBoxContainer, text: String) -> void:
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", 21)
    label.add_theme_color_override("font_color", UiStyle.CREAM)
    box.add_child(label)


func _panel_button(box: VBoxContainer, text: String, action: Callable) -> void:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size = Vector2(0, 48)
    button.pressed.connect(action)
    box.add_child(button)


# ── Dev screenshots: godot -- screenshots ──

func _screenshot_run() -> void:
    await get_tree().create_timer(0.6).timeout
    await _capture("menu")
    GameManager.start_match(4, 15)
    await get_tree().create_timer(1.0).timeout
    await _capture("board")
    GameManager.roll_dice()
    await get_tree().create_timer(1.2).timeout
    await _capture("board_move")
    MinigameManager.select_minigame(4)
    _start_minigame()
    await get_tree().create_timer(1.2).timeout
    await _capture("minigame")
    get_tree().quit(0)


func _capture(shot_name: String) -> void:
    await RenderingServer.frame_post_draw
    var image := get_viewport().get_texture().get_image()
    var dir := ProjectSettings.globalize_path("res://dev_screenshots")
    DirAccess.make_dir_recursive_absolute(dir)
    image.save_png(dir + "/" + shot_name + ".png")
    print("[SHOT] " + shot_name)


# ── Autotest (headless verification): godot --headless -- autotest ──

func _setup_autotest() -> void:
    print("[AUTOTEST] begin")
    BoardManager.route_choice_required.connect(
        func(_pid, options): BoardManager.choose_route.call_deferred(options[0])
    )
    TurnManager.turn_started.connect(func(_pid): GameManager.roll_dice.call_deferred())
    BoardManager.move_finished.connect(func(_pid): GameManager.end_turn.call_deferred())
    GameManager.minigame_rewards_granted.connect(
        func(_ranking, _rewards): GameManager.continue_after_minigame.call_deferred()
    )
    TrophyManager.trophy_offer.connect(func(_pid, _cost): TrophyManager.buy.call_deferred())
    ItemManager.shop_opened.connect(_autotest_on_shop)
    BuildingManager.build_offer.connect(
        func(_pid, _tile, _cost): BuildingManager.confirm.call_deferred()
    )
    BuildingManager.upgrade_offer.connect(
        func(_pid, _tile, _cost, _level): BuildingManager.confirm.call_deferred()
    )
    GameManager.state_changed.connect(_autotest_on_state)
    GameManager.match_ended.connect(_autotest_on_match_end)
    get_tree().create_timer(60.0).timeout.connect(_autotest_watchdog)
    GameManager.start_match.call_deferred(3, 10)


var _autotest_matches_played := 0


func _autotest_watchdog() -> void:
    if _autotest_matches_played < 2:
        push_error("[AUTOTEST] TIMEOUT")
        get_tree().quit(1)


func _autotest_on_shop(player_id: int, offers: Array) -> void:
    var item: Dictionary = offers[0]
    if EconomyManager.get_coins(player_id) >= int(item["price"]):
        ItemManager.buy.bind(player_id, String(item["id"])).call_deferred()


func _autotest_on_state(new_state: int) -> void:
    if new_state == GameManager.State.MINIGAME:
        var ids: Array = PlayerManager.get_player_ids().duplicate()
        ids.shuffle()
        MinigameManager.report_finished.call_deferred(ids)


func _autotest_on_match_end(final_ranking: Array) -> void:
    print("[AUTOTEST] match finished after %d rounds" % GameManager.current_round)
    for i in final_ranking.size():
        var pid: int = final_ranking[i]
        var coins := EconomyManager.get_coins(pid)
        var trophies := TrophyManager.get_trophies(pid)
        print("[AUTOTEST] %d. %s — %d trophies, %d coins" % [
            i + 1, PlayerManager.get_player(pid)["name"], trophies, coins,
        ])
        if coins < 0 or trophies < 0:
            push_error("[AUTOTEST] negative coins or trophies")
            get_tree().quit(1)
            return
    _autotest_matches_played += 1
    if _autotest_matches_played == 1:
        print("[AUTOTEST] starting second match without restart")
        GameManager.return_to_menu()
        GameManager.start_match.call_deferred(2, 10)
    else:
        print("[AUTOTEST] OK")
        get_tree().quit(0)

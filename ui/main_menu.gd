extends Control

# Main menu: player count + match length, then hands off to GameManager.

const ROUND_OPTIONS: Array[int] = [10, 15, 20, 30]

var players_option: OptionButton
var rounds_option: OptionButton
var ip_edit: LineEdit
var net_status: Label
var lobby_panel: PanelContainer
var lobby_label: Label
var lobby_start: Button


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

    var net_card := PanelContainer.new()
    net_card.position = Vector2(880, 270)
    net_card.custom_minimum_size = Vector2(330, 0)
    add_child(net_card)

    var net_box := VBoxContainer.new()
    net_box.add_theme_constant_override("separation", 12)
    net_card.add_child(net_box)

    var net_title := Label.new()
    net_title.text = "Multiplayer LAN (Steam wkrotce)"
    net_title.add_theme_color_override("font_color", UiStyle.CREAM)
    net_box.add_child(net_title)

    var host_button := Button.new()
    host_button.text = "Hostuj gre"
    host_button.pressed.connect(_on_host_pressed)
    net_box.add_child(host_button)

    ip_edit = LineEdit.new()
    ip_edit.placeholder_text = "Adres IP hosta"
    ip_edit.text = "127.0.0.1"
    net_box.add_child(ip_edit)

    var join_button := Button.new()
    join_button.text = "Dolacz do gry"
    join_button.pressed.connect(_on_join_pressed)
    net_box.add_child(join_button)

    net_status = Label.new()
    net_status.text = ""
    net_status.add_theme_font_size_override("font_size", 14)
    net_status.add_theme_color_override("font_color", Color(1, 0.75, 0.5))
    net_box.add_child(net_status)

    lobby_panel = PanelContainer.new()
    lobby_panel.position = Vector2(440, 200)
    lobby_panel.custom_minimum_size = Vector2(400, 0)
    lobby_panel.visible = false
    add_child(lobby_panel)

    var lobby_box := VBoxContainer.new()
    lobby_box.add_theme_constant_override("separation", 14)
    lobby_panel.add_child(lobby_box)

    var lobby_title := Label.new()
    lobby_title.text = "Lobby"
    lobby_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(lobby_title, 30, UiStyle.GOLD)
    lobby_box.add_child(lobby_title)

    lobby_label = Label.new()
    lobby_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    lobby_label.add_theme_color_override("font_color", UiStyle.CREAM)
    lobby_box.add_child(lobby_label)

    lobby_start = Button.new()
    lobby_start.text = "Start meczu"
    lobby_start.custom_minimum_size = Vector2(0, 48)
    lobby_start.pressed.connect(_on_lobby_start_pressed)
    lobby_box.add_child(lobby_start)

    var lobby_leave := Button.new()
    lobby_leave.text = "Rozlacz"
    lobby_leave.pressed.connect(_on_lobby_leave_pressed)
    lobby_box.add_child(lobby_leave)

    NetworkManager.hosted.connect(_on_net_hosted)
    NetworkManager.joined.connect(_on_net_joined)
    NetworkManager.connection_failed.connect(_on_net_failed)
    NetworkManager.disconnected_from_host.connect(_on_net_disconnected)
    NetworkManager.network_players_changed.connect(_on_net_players_changed)

    var controls := Label.new()
    controls.text = "Sterowanie w minigrze:  G1 WASD    G2 strzalki    G3 TFGH    G4 IJKL  |  online: WASD lub strzalki"
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


func _on_host_pressed() -> void:
    net_status.text = ""
    NetworkManager.host_game()


func _on_join_pressed() -> void:
    net_status.text = "Lacze z %s..." % ip_edit.text
    NetworkManager.join_game(ip_edit.text)


func _on_net_hosted() -> void:
    lobby_panel.visible = true
    lobby_start.visible = true
    _refresh_lobby()


func _on_net_joined() -> void:
    net_status.text = ""
    lobby_panel.visible = true
    lobby_start.visible = false
    lobby_label.text = "Polaczono! Czekam na start od hosta..."


func _on_net_failed() -> void:
    net_status.text = "Nie udalo sie polaczyc."
    lobby_panel.visible = false


func _on_net_disconnected() -> void:
    net_status.text = "Rozlaczono z hostem."
    lobby_panel.visible = false


func _on_net_players_changed(count: int) -> void:
    _refresh_lobby()
    if NetworkManager.is_client():
        return
    lobby_start.disabled = count < 2


func _refresh_lobby() -> void:
    if NetworkManager.is_online and NetworkManager.is_server():
        lobby_label.text = "Graczy w lobby: %d / 4\nPodaj znajomym swoj adres IP." % NetworkManager.player_count()


func _on_lobby_start_pressed() -> void:
    NetworkManager.start_network_match(rounds_option.get_selected_id())


func _on_lobby_leave_pressed() -> void:
    NetworkManager.leave_game()
    lobby_panel.visible = false
    net_status.text = ""

extends Control

# Main menu: player count + match length, then hands off to GameManager.

const ROUND_OPTIONS: Array[int] = [10, 15, 20, 30]
const ACCESSORY_NAMES: Array[String] = ["Czapka", "Okulary", "Kokarda", "Kwiatki"]

var players_option: OptionButton
var rounds_option: OptionButton
var ip_edit: LineEdit
var code_edit: LineEdit
var net_status: Label
var lobby_panel: PanelContainer
var lobby_label: Label
var lobby_ip_label: Label
var lobby_roster: VBoxContainer
var my_name_edit: LineEdit
var my_color_button: Button
var my_accessory_button: Button
var my_ready_button: Button
var lobby_start: Button

var _my_color_index := 0
var _my_accessory := 0


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

    code_edit = LineEdit.new()
    code_edit.placeholder_text = "Kod dolaczenia (od hosta)"
    code_edit.max_length = 4
    net_box.add_child(code_edit)

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
    lobby_panel.position = Vector2(410, 130)
    lobby_panel.custom_minimum_size = Vector2(460, 0)
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

    lobby_ip_label = Label.new()
    lobby_ip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    lobby_ip_label.add_theme_font_size_override("font_size", 14)
    lobby_ip_label.add_theme_color_override("font_color", Color(0.75, 0.9, 1.0))
    lobby_box.add_child(lobby_ip_label)

    lobby_roster = VBoxContainer.new()
    lobby_roster.add_theme_constant_override("separation", 6)
    lobby_box.add_child(lobby_roster)

    var my_title := Label.new()
    my_title.text = "Twoja postac"
    my_title.add_theme_color_override("font_color", UiStyle.CREAM)
    lobby_box.add_child(my_title)

    var my_row := HBoxContainer.new()
    my_row.add_theme_constant_override("separation", 8)
    lobby_box.add_child(my_row)

    my_name_edit = LineEdit.new()
    my_name_edit.placeholder_text = "Nazwa"
    my_name_edit.custom_minimum_size = Vector2(150, 0)
    my_name_edit.text_submitted.connect(func(_t): _send_my_profile())
    my_name_edit.focus_exited.connect(_send_my_profile)
    my_row.add_child(my_name_edit)

    my_color_button = Button.new()
    my_color_button.custom_minimum_size = Vector2(80, 0)
    my_color_button.pressed.connect(_on_cycle_color)
    my_row.add_child(my_color_button)

    my_accessory_button = Button.new()
    my_accessory_button.custom_minimum_size = Vector2(96, 0)
    my_accessory_button.pressed.connect(_on_cycle_accessory)
    my_row.add_child(my_accessory_button)

    my_ready_button = Button.new()
    my_ready_button.custom_minimum_size = Vector2(0, 46)
    my_ready_button.pressed.connect(_on_ready_pressed)
    lobby_box.add_child(my_ready_button)

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
    NetworkManager.upnp_completed.connect(_on_upnp_completed)
    NetworkManager.code_rejected.connect(_on_code_rejected)
    NetworkManager.lobby_updated.connect(func(_profiles): _refresh_lobby())

    _update_my_buttons()

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
    net_status.text = "Lacze z %s... (do %d s)" % [ip_edit.text.strip_edges(), int(NetworkManager.CONNECT_TIMEOUT)]
    NetworkManager.join_code = code_edit.text.strip_edges()
    NetworkManager.join_game(ip_edit.text)


func _on_code_rejected() -> void:
    net_status.text = "Bledny kod dolaczenia (albo lobby pelne)."
    lobby_panel.visible = false


func _on_net_hosted() -> void:
    lobby_panel.visible = true
    lobby_start.visible = true
    var lan := NetworkManager.get_lan_addresses()
    lobby_ip_label.text = "LAN: %s\nInternet: szukam adresu (UPnP)..." % (
        ", ".join(PackedStringArray(lan)) if not lan.is_empty() else "brak"
    )
    _refresh_lobby()


func _on_upnp_completed(success: bool, external_ip: String) -> void:
    var lan := NetworkManager.get_lan_addresses()
    var lan_text: String = ", ".join(PackedStringArray(lan)) if not lan.is_empty() else "brak"
    if success and external_ip != "":
        lobby_ip_label.text = (
            "LAN (ta sama siec): %s\nInternet: %s (port 7777 otwarty przez UPnP)\n" +
            "Jesli Windows zapyta o zapore — kliknij Zezwol!"
        ) % [lan_text, external_ip]
    else:
        lobby_ip_label.text = (
            "LAN (ta sama siec): %s\nInternet: UPnP nie zadzialal — przekieruj port 7777 UDP\n" +
            "na routerze albo uzyjcie VPN (np. Radmin/ZeroTier)."
        ) % lan_text


func _on_net_joined() -> void:
    net_status.text = ""
    lobby_panel.visible = true
    lobby_start.visible = false
    lobby_label.text = "Polaczono! Czekam na start od hosta..."


func _on_net_failed() -> void:
    net_status.text = "Nie udalo sie polaczyc.\nSprawdz IP (przez internet: adres publiczny\nhosta, nie 192.168.x) i zapore Windows."
    lobby_panel.visible = false


func _on_net_disconnected() -> void:
    net_status.text = "Rozlaczono z hostem."
    lobby_panel.visible = false


func _on_net_players_changed(_count: int) -> void:
    _refresh_lobby()


func _refresh_lobby() -> void:
    if not NetworkManager.is_online:
        return
    if NetworkManager.is_server():
        lobby_label.text = "Graczy w lobby: %d / 4\nKod dolaczenia: %s" % [
            NetworkManager.player_count(), NetworkManager.join_code,
        ]
    _rebuild_roster()
    _sync_my_controls()
    if NetworkManager.is_server():
        var all_ready := NetworkManager.player_count() >= 2
        for peer_id in NetworkManager.lobby_profiles:
            if not NetworkManager.lobby_profiles[peer_id].get("ready", false):
                all_ready = false
                break
        lobby_start.disabled = not all_ready
        lobby_start.text = "Start meczu" if all_ready else "Czekam, az wszyscy beda gotowi..."


func _rebuild_roster() -> void:
    for child in lobby_roster.get_children():
        child.queue_free()
    var profiles: Dictionary = NetworkManager.lobby_profiles
    var peer_ids: Array = profiles.keys()
    peer_ids.sort()
    var my_id := multiplayer.get_unique_id()
    for peer_id in peer_ids:
        var profile: Dictionary = profiles[peer_id]
        var row := PanelContainer.new()
        var row_style := UiStyle.flat(Color(1, 1, 1, 0.06), 10)
        row_style.set_content_margin_all(8)
        row.add_theme_stylebox_override("panel", row_style)
        lobby_roster.add_child(row)

        var hrow := HBoxContainer.new()
        hrow.add_theme_constant_override("separation", 10)
        row.add_child(hrow)

        var preview := Control.new()
        preview.custom_minimum_size = Vector2(46, 46)
        hrow.add_child(preview)
        var bear := BearCharacter.new()
        var color_index: int = int(profile.get("color_index", 0)) % PlayerManager.PLAYER_COLORS.size()
        bear.base_color = PlayerManager.PLAYER_COLORS[color_index]
        bear.accessory = int(profile.get("accessory", 0))
        bear.scale = Vector2(0.5, 0.5)
        bear.position = Vector2(23, 40)
        preview.add_child(bear)

        var name_label := Label.new()
        name_label.text = String(profile.get("name", "Gracz"))
        name_label.custom_minimum_size = Vector2(140, 0)
        name_label.add_theme_color_override("font_color", UiStyle.CREAM)
        hrow.add_child(name_label)

        var tag := Label.new()
        if peer_id == my_id:
            tag.text = "TY"
        elif peer_id == 1:
            tag.text = "HOST"
        tag.custom_minimum_size = Vector2(48, 0)
        tag.add_theme_font_size_override("font_size", 13)
        tag.add_theme_color_override("font_color", Color(0.7, 0.85, 1.0))
        hrow.add_child(tag)

        var is_ready: bool = profile.get("ready", false)
        var ready_label := Label.new()
        ready_label.text = "GOTOWY" if is_ready else "..."
        ready_label.add_theme_font_size_override("font_size", 14)
        ready_label.add_theme_color_override(
            "font_color", Color(0.4, 0.9, 0.5) if is_ready else Color(0.9, 0.7, 0.3)
        )
        hrow.add_child(ready_label)


func _sync_my_controls() -> void:
    var my_id := multiplayer.get_unique_id()
    if not NetworkManager.lobby_profiles.has(my_id):
        return
    var mine: Dictionary = NetworkManager.lobby_profiles[my_id]
    if my_name_edit.text == "" and not my_name_edit.has_focus():
        my_name_edit.text = String(mine.get("name", ""))
    _my_color_index = int(mine.get("color_index", _my_color_index))
    _my_accessory = int(mine.get("accessory", _my_accessory))
    _update_my_buttons()
    var is_ready: bool = mine.get("ready", false)
    my_ready_button.text = "Nie gotowy ✗" if is_ready else "Gotowy ✓"


func _update_my_buttons() -> void:
    var color: Color = PlayerManager.PLAYER_COLORS[_my_color_index]
    my_color_button.text = "Kolor"
    my_color_button.add_theme_stylebox_override("normal", UiStyle.flat(color, 8))
    my_color_button.add_theme_stylebox_override("hover", UiStyle.flat(color.lightened(0.15), 8))
    my_color_button.add_theme_stylebox_override("pressed", UiStyle.flat(color.darkened(0.15), 8))
    my_accessory_button.text = ACCESSORY_NAMES[_my_accessory]


func _on_cycle_color() -> void:
    _my_color_index = (_my_color_index + 1) % PlayerManager.PLAYER_COLORS.size()
    _update_my_buttons()
    _send_my_profile()


func _on_cycle_accessory() -> void:
    _my_accessory = (_my_accessory + 1) % ACCESSORY_NAMES.size()
    _update_my_buttons()
    _send_my_profile()


func _send_my_profile() -> void:
    if not NetworkManager.is_online:
        return
    NetworkManager.update_my_profile(my_name_edit.text.strip_edges(), _my_color_index, _my_accessory)


func _on_ready_pressed() -> void:
    var my_id := multiplayer.get_unique_id()
    var mine: Dictionary = NetworkManager.lobby_profiles.get(my_id, {})
    NetworkManager.set_ready(not mine.get("ready", false))


func _on_lobby_start_pressed() -> void:
    NetworkManager.start_network_match(rounds_option.get_selected_id())


func _on_lobby_leave_pressed() -> void:
    NetworkManager.leave_game()
    lobby_panel.visible = false
    net_status.text = ""
    my_name_edit.text = ""
    _my_color_index = 0
    _my_accessory = 0
    _update_my_buttons()
    for child in lobby_roster.get_children():
        child.queue_free()

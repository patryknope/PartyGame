extends Node

# Etap 2 network layer (GDD_PHASE2): host-authoritative peer-to-peer.
# All game logic runs on the host; clients send input requests and
# receive relayed events + state snapshots. Transport is Godot's
# High-Level Multiplayer API — ENet (LAN) today; swapping in
# GodotSteam's SteamMultiplayerPeer only changes _create_*_peer()
# (see STEAM.md).

signal hosted
signal joined
signal connection_failed
signal disconnected_from_host
signal network_players_changed(count: int)
signal upnp_completed(success: bool, external_ip: String)
signal minigame_start_requested
signal minigame_positions(positions: Dictionary)
signal minigame_event(kind: String, data: Dictionary)

const PORT := 7777
const MAX_CLIENTS := 3
const CONNECT_TIMEOUT := 12.0

var is_online := false
var my_player_id := 0
var peer_to_player := {}

var _join_order: Array = []
var _connected := false
var _upnp_thread: Thread


func get_lan_addresses() -> Array:
    var addresses: Array = []
    for address in IP.get_local_addresses():
        if address.begins_with("192.168.") or address.begins_with("10."):
            addresses.append(address)
        elif address.begins_with("172."):
            var second := int(address.split(".")[1])
            if second >= 16 and second <= 31:
                addresses.append(address)
    return addresses


func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)
    _connect_relays()


func _exit_tree() -> void:
    if _upnp_thread != null and _upnp_thread.is_started():
        _upnp_thread.wait_to_finish()
        _upnp_thread = null


func is_server() -> bool:
    return not is_online or multiplayer.is_server()


func is_client() -> bool:
    return is_online and not multiplayer.is_server()


func player_count() -> int:
    return 1 + _join_order.size()


# ── Hosting / joining ────────────────────────────────────────────

func _create_host_peer() -> MultiplayerPeer:
    # SteamMultiplayerPeer.create_host() goes here once GodotSteam is set up.
    var peer := ENetMultiplayerPeer.new()
    peer.create_server(PORT, MAX_CLIENTS)
    return peer


func _create_client_peer(address: String) -> MultiplayerPeer:
    # SteamMultiplayerPeer.create_client(lobby_owner) goes here for Steam.
    var peer := ENetMultiplayerPeer.new()
    peer.create_client(address, PORT)
    return peer


func host_game() -> void:
    multiplayer.multiplayer_peer = _create_host_peer()
    is_online = true
    my_player_id = 0
    _join_order.clear()
    hosted.emit()
    network_players_changed.emit(player_count())
    _start_upnp()


func join_game(address: String) -> void:
    _connected = false
    multiplayer.multiplayer_peer = _create_client_peer(address.strip_edges())
    is_online = true
    get_tree().create_timer(CONNECT_TIMEOUT).timeout.connect(_on_connect_timeout)


func _on_connect_timeout() -> void:
    if is_online and not multiplayer.is_server() and not _connected:
        leave_game()
        connection_failed.emit()


func _start_upnp() -> void:
    # Tries to open UDP 7777 on the router so friends can join over
    # the internet without manual port forwarding. Runs in a thread —
    # discovery takes a few seconds.
    if _upnp_thread != null and _upnp_thread.is_started():
        return
    _upnp_thread = Thread.new()
    _upnp_thread.start(_upnp_worker)


func _upnp_worker() -> void:
    var upnp := UPNP.new()
    var success := false
    var external_ip := ""
    if upnp.discover() == UPNP.UPNP_RESULT_SUCCESS:
        var gateway := upnp.get_gateway()
        if gateway != null and gateway.is_valid_gateway():
            var mapped := upnp.add_port_mapping(PORT, PORT, "PartyGame", "UDP")
            success = mapped == UPNP.UPNP_RESULT_SUCCESS
            external_ip = upnp.query_external_address()
    call_deferred("_upnp_done", success, external_ip)


func _upnp_done(success: bool, external_ip: String) -> void:
    if _upnp_thread != null:
        _upnp_thread.wait_to_finish()
        _upnp_thread = null
    upnp_completed.emit(success, external_ip)


func leave_game() -> void:
    if multiplayer.multiplayer_peer != null:
        multiplayer.multiplayer_peer.close()
    multiplayer.multiplayer_peer = null
    is_online = false
    my_player_id = 0
    peer_to_player.clear()
    _join_order.clear()


func _on_peer_connected(peer_id: int) -> void:
    if not multiplayer.is_server():
        return
    if _join_order.size() >= MAX_CLIENTS:
        multiplayer.multiplayer_peer.disconnect_peer(peer_id)
        return
    _join_order.append(peer_id)
    network_players_changed.emit(player_count())


func _on_peer_disconnected(peer_id: int) -> void:
    if not multiplayer.is_server():
        return
    _join_order.erase(peer_id)
    network_players_changed.emit(player_count())
    # v1: no grace period yet — mid-match disconnect aborts the session
    # (GDD grace period 5 s / timeout 60 s is an Etap 2.1 task).
    if GameManager.state != GameManager.State.MAIN_MENU:
        GameManager.return_to_menu()


func _on_connected_to_server() -> void:
    _connected = true
    joined.emit()


func _on_connection_failed() -> void:
    leave_game()
    connection_failed.emit()


func _on_server_disconnected() -> void:
    leave_game()
    disconnected_from_host.emit()
    if GameManager.state != GameManager.State.MAIN_MENU:
        GameManager.return_to_menu()


# ── Match start ──────────────────────────────────────────────────

func start_network_match(rounds: int) -> void:
    if not multiplayer.is_server():
        return
    peer_to_player = {1: 0}
    for i in _join_order.size():
        peer_to_player[_join_order[i]] = i + 1
    _net_match_setup.rpc(peer_to_player, rounds)
    GameManager.start_match(player_count(), rounds)


@rpc("authority", "call_remote", "reliable")
func _net_match_setup(mapping: Dictionary, _rounds: int) -> void:
    peer_to_player = mapping
    my_player_id = mapping[multiplayer.get_unique_id()]
    PlayerManager.setup_players(mapping.size())


# ── Client → host input requests ─────────────────────────────────

func send_request(kind: String, args: Array = []) -> void:
    _request.rpc_id(1, kind, args)


@rpc("any_peer", "call_remote", "reliable")
func _request(kind: String, args: Array) -> void:
    if not multiplayer.is_server():
        return
    var sender_player: int = peer_to_player.get(multiplayer.get_remote_sender_id(), -1)
    if sender_player != TurnManager.current_player_id():
        return
    match kind:
        "roll":
            GameManager.roll_dice(args[0])
        "end_turn":
            GameManager.end_turn()
        "route":
            BoardManager.choose_route(args[0])
        "trophy_buy":
            TrophyManager.buy()
        "trophy_skip":
            TrophyManager.skip()
        "shop_buy":
            ItemManager.buy(sender_player, args[0])
        "item_use":
            ItemManager.use_item(sender_player, args[0], args[1])
        "build_confirm":
            BuildingManager.confirm()
        "build_skip":
            BuildingManager.skip()
        "poker_redraw":
            CasinoManager.redraw(args[0])


# ── Host → clients event relay ───────────────────────────────────

func _connect_relays() -> void:
    GameManager.state_changed.connect(func(a): _relay("state_changed", [a]))
    GameManager.round_started.connect(func(a): _relay("round_started", [a]))
    GameManager.dice_rolled.connect(func(a, b): _relay("dice_rolled", [a, b]))
    GameManager.minigame_rewards_granted.connect(func(a, b): _relay("minigame_rewards_granted", [a, b]))
    GameManager.match_ended.connect(func(a): _relay("match_ended", [a]))
    TurnManager.turn_started.connect(func(a): _relay("turn_started", [a]))
    BoardManager.player_stepped.connect(func(a, b): _relay("player_stepped", [a, b]))
    BoardManager.player_placed.connect(func(a, b): _relay("player_placed", [a, b]))
    BoardManager.route_choice_required.connect(func(a, b): _relay("route_choice_required", [a, b]))
    BoardManager.move_finished.connect(func(a): _relay("move_finished", [a]))
    BoardManager.tile_resolved.connect(func(a, b, c, d): _relay("tile_resolved", [a, b, c, d]))
    BoardManager.start_passed.connect(func(a, b): _relay("start_passed", [a, b]))
    EconomyManager.coins_changed.connect(func(a, b): _relay("coins_changed", [a, b]))
    TrophyManager.trophy_moved.connect(func(a): _relay("trophy_moved", [a]))
    TrophyManager.trophy_offer.connect(func(a, b): _relay("trophy_offer", [a, b]))
    TrophyManager.trophy_bought.connect(func(a, b): _relay("trophy_bought", [a, b]))
    TrophyManager.trophies_changed.connect(func(a, b): _relay("trophies_changed", [a, b]))
    ItemManager.inventory_changed.connect(func(a, b): _relay("inventory_changed", [a, b]))
    ItemManager.shop_opened.connect(func(a, b): _relay("shop_opened", [a, b]))
    ItemManager.item_used.connect(func(a, b, c): _relay("item_used", [a, b, c]))
    ItemManager.item_blocked.connect(func(a): _relay("item_blocked", [a]))
    ItemManager.trap_triggered.connect(func(a, b, c): _relay("trap_triggered", [a, b, c]))
    BuildingManager.build_offer.connect(func(a, b, c): _relay("build_offer", [a, b, c]))
    BuildingManager.upgrade_offer.connect(func(a, b, c, d): _relay("upgrade_offer", [a, b, c, d]))
    BuildingManager.building_changed.connect(func(a, b, c): _relay("building_changed", [a, b, c]))
    BuildingManager.buildings_reset.connect(func(): _relay("buildings_reset", []))
    BuildingManager.income_granted.connect(func(a, b): _relay("income_granted", [a, b]))
    CasinoManager.poker_started.connect(func(a, b): _relay("poker_started", [a, b]))
    CasinoManager.poker_finished.connect(func(a, b, c, d): _relay("poker_finished", [a, b, c, d]))
    GameManager.jackpot_result.connect(func(a, b, c): _relay("jackpot_result", [a, b, c]))


func _relay(event: String, args: Array) -> void:
    if is_online and multiplayer.is_server():
        _client_event.rpc(event, args, _capture_state())


func _capture_state() -> Dictionary:
    return {
        "gm_state": GameManager.state,
        "round": GameManager.current_round,
        "total_rounds": GameManager.total_rounds,
        "last_roll": GameManager.last_roll,
        "turn_order": TurnManager._order,
        "turn_index": TurnManager._current_index,
        "coins": EconomyManager._coins,
        "positions": BoardManager.positions,
        "trophy_counts": TrophyManager._counts,
        "trophy_tile": TrophyManager.trophy_tile,
        "inventories": ItemManager._inventories,
        "buildings": BuildingManager.buildings,
        "minigame_id": MinigameManager.current.get("id", ""),
    }


@rpc("authority", "call_remote", "reliable")
func _client_event(event: String, args: Array, state: Dictionary) -> void:
    _apply_state(state)
    _reemit(event, args)


func _apply_state(state: Dictionary) -> void:
    GameManager.state = state["gm_state"]
    GameManager.current_round = state["round"]
    GameManager.total_rounds = state["total_rounds"]
    GameManager.last_roll = state["last_roll"]
    TurnManager._order = state["turn_order"]
    TurnManager._current_index = state["turn_index"]
    EconomyManager._coins = state["coins"]
    BoardManager.positions = state["positions"]
    TrophyManager._counts = state["trophy_counts"]
    TrophyManager.trophy_tile = state["trophy_tile"]
    ItemManager._inventories = state["inventories"]
    BuildingManager.buildings = state["buildings"]
    if state["minigame_id"] != "":
        for minigame in MinigameManager.MINIGAMES:
            if minigame["id"] == state["minigame_id"]:
                MinigameManager.current = minigame


func _reemit(event: String, args: Array) -> void:
    match event:
        "state_changed":
            GameManager.state_changed.emit(args[0])
        "round_started":
            GameManager.round_started.emit(args[0])
        "dice_rolled":
            GameManager.dice_rolled.emit(args[0], args[1])
        "minigame_rewards_granted":
            GameManager.minigame_rewards_granted.emit(args[0], args[1])
        "match_ended":
            GameManager.match_ended.emit(args[0])
        "turn_started":
            TurnManager.turn_started.emit(args[0])
        "player_stepped":
            BoardManager.player_stepped.emit(args[0], args[1])
        "player_placed":
            BoardManager.player_placed.emit(args[0], args[1])
        "route_choice_required":
            BoardManager.route_choice_required.emit(args[0], args[1])
        "move_finished":
            BoardManager.move_finished.emit(args[0])
        "tile_resolved":
            BoardManager.tile_resolved.emit(args[0], args[1], args[2], args[3])
        "start_passed":
            BoardManager.start_passed.emit(args[0], args[1])
        "coins_changed":
            EconomyManager.coins_changed.emit(args[0], args[1])
        "trophy_moved":
            TrophyManager.trophy_moved.emit(args[0])
        "trophy_offer":
            TrophyManager.trophy_offer.emit(args[0], args[1])
        "trophy_bought":
            TrophyManager.trophy_bought.emit(args[0], args[1])
        "trophies_changed":
            TrophyManager.trophies_changed.emit(args[0], args[1])
        "inventory_changed":
            ItemManager.inventory_changed.emit(args[0], args[1])
        "shop_opened":
            ItemManager.shop_opened.emit(args[0], args[1])
        "item_used":
            ItemManager.item_used.emit(args[0], args[1], args[2])
        "item_blocked":
            ItemManager.item_blocked.emit(args[0])
        "trap_triggered":
            ItemManager.trap_triggered.emit(args[0], args[1], args[2])
        "build_offer":
            BuildingManager.build_offer.emit(args[0], args[1], args[2])
        "upgrade_offer":
            BuildingManager.upgrade_offer.emit(args[0], args[1], args[2], args[3])
        "building_changed":
            BuildingManager.building_changed.emit(args[0], args[1], args[2])
        "buildings_reset":
            BuildingManager.buildings_reset.emit()
        "income_granted":
            BuildingManager.income_granted.emit(args[0], args[1])
        "poker_started":
            CasinoManager.poker_started.emit(args[0], args[1])
        "poker_finished":
            CasinoManager.poker_finished.emit(args[0], args[1], args[2], args[3])
        "jackpot_result":
            GameManager.jackpot_result.emit(args[0], args[1], args[2])


# ── Minigame networking ──────────────────────────────────────────

func start_minigame_for_all() -> void:
    if is_online and multiplayer.is_server():
        _minigame_start.rpc()
    minigame_start_requested.emit()


@rpc("authority", "call_remote", "reliable")
func _minigame_start() -> void:
    minigame_start_requested.emit()


func send_minigame_position(pos: Vector2) -> void:
    _mg_pos.rpc_id(1, pos)


@rpc("any_peer", "call_remote", "unreliable_ordered")
func _mg_pos(pos: Vector2) -> void:
    if not multiplayer.is_server():
        return
    var player_id: int = peer_to_player.get(multiplayer.get_remote_sender_id(), -1)
    if player_id >= 0:
        minigame_positions.emit({player_id: pos})


func broadcast_minigame_positions(positions: Dictionary) -> void:
    _mg_positions.rpc(positions)


@rpc("authority", "call_remote", "unreliable_ordered")
func _mg_positions(positions: Dictionary) -> void:
    minigame_positions.emit(positions)


func broadcast_minigame_event(kind: String, data: Dictionary) -> void:
    _mg_event.rpc(kind, data)


@rpc("authority", "call_remote", "reliable")
func _mg_event(kind: String, data: Dictionary) -> void:
    minigame_event.emit(kind, data)

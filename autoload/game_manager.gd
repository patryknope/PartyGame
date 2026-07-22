extends Node

# Match flow + minimal state machine (GDD_PHASE2):
# MainMenu, TuraGracza, RuchGracza, Minigrka, KoniecMeczu.

enum State { MAIN_MENU, PLAYER_TURN, PLAYER_MOVE, MINIGAME, MATCH_END }

signal state_changed(new_state: int)
signal round_started(round_number: int)
signal dice_rolled(player_id: int, result: int)
signal minigame_rewards_granted(ranking: Array, rewards: Array)
signal match_ended(final_ranking: Array)

# Placeholder economy values — final balance is an open question in the GDD.
const STARTING_COINS := 20
const MINIGAME_REWARDS: Array[int] = [15, 10, 5, 2]

var state: int = State.MAIN_MENU
var total_rounds := 15
var current_round := 0
var last_roll := 0
var last_minigame_ranking: Array = []
var last_minigame_rewards: Array = []


func _ready() -> void:
    TurnManager.all_turns_completed.connect(_on_all_turns_completed)
    BoardManager.move_finished.connect(_on_move_finished)
    MinigameManager.minigame_finished.connect(_on_minigame_finished)


func start_match(player_count: int, rounds: int) -> void:
    total_rounds = rounds
    current_round = 1
    PlayerManager.setup_players(player_count)
    var ids := PlayerManager.get_player_ids()
    EconomyManager.reset(ids, STARTING_COINS)
    BoardManager.reset(ids)
    TrophyManager.reset(ids)
    ItemManager.reset(ids)
    BuildingManager.reset(ids)
    TurnManager.reset(ids)
    _set_state(State.PLAYER_TURN)
    round_started.emit(current_round)
    TurnManager.start_round()


func roll_dice(dice_index: int = 0) -> void:
    if state != State.PLAYER_TURN:
        return
    var player_id := TurnManager.current_player_id()
    last_roll = Dice.roll(Dice.TYPES[dice_index]["faces"])
    dice_rolled.emit(player_id, last_roll)
    _set_state(State.PLAYER_MOVE)
    BoardManager.begin_move(player_id, last_roll)


func local_can_act(player_id: int) -> bool:
    if not NetworkManager.is_online:
        return true
    return NetworkManager.my_player_id == player_id


func request_roll(dice_index: int) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("roll", [dice_index])
    else:
        roll_dice(dice_index)


func request_end_turn() -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("end_turn")
    else:
        end_turn()


func request_route(tile_id: int) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("route", [tile_id])
    else:
        BoardManager.choose_route(tile_id)


func request_trophy(buy: bool) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("trophy_buy" if buy else "trophy_skip")
    elif buy:
        TrophyManager.buy()
    else:
        TrophyManager.skip()


func request_shop_buy(player_id: int, item_id: String) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("shop_buy", [item_id])
    else:
        ItemManager.buy(player_id, item_id)


func request_item_use(player_id: int, item_id: String, target_id: int = -1) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("item_use", [item_id, target_id])
    else:
        ItemManager.use_item(player_id, item_id, target_id)


func request_building(confirm: bool) -> void:
    if NetworkManager.is_client():
        NetworkManager.send_request("build_confirm" if confirm else "build_skip")
    elif confirm:
        BuildingManager.confirm()
    else:
        BuildingManager.skip()


func move_forced(steps: int) -> void:
    if state != State.PLAYER_TURN:
        return
    var player_id := TurnManager.current_player_id()
    last_roll = steps
    dice_rolled.emit(player_id, steps)
    _set_state(State.PLAYER_MOVE)
    BoardManager.begin_move(player_id, steps)


func roll_pair() -> Array:
    var faces: Array = Dice.TYPES[0]["faces"]
    return [Dice.roll(faces), Dice.roll(faces)]


func end_turn() -> void:
    if state != State.PLAYER_TURN:
        return
    TurnManager.end_turn()


func continue_after_minigame() -> void:
    if current_round >= total_rounds:
        _set_state(State.MATCH_END)
        match_ended.emit(TrophyManager.ranking())
    else:
        current_round += 1
        _set_state(State.PLAYER_TURN)
        round_started.emit(current_round)
        TurnManager.start_round()


func return_to_menu() -> void:
    _set_state(State.MAIN_MENU)


func _on_move_finished(player_id: int) -> void:
    if NetworkManager.is_client():
        return
    if last_roll > 0:
        BoardManager.resolve_tile(player_id)
        var tile_id: int = BoardManager.positions[player_id]
        ItemManager.trigger_trap(player_id, tile_id)
        if BoardManager.get_tile(tile_id)["type"] == "shop":
            ItemManager.open_shop(player_id)
        else:
            BuildingManager.consider_offer(player_id, tile_id)
    _set_state(State.PLAYER_TURN)


func _on_all_turns_completed() -> void:
    if NetworkManager.is_client():
        return
    MinigameManager.select_minigame(PlayerManager.player_count(), NetworkManager.is_online)
    _set_state(State.MINIGAME)


func _on_minigame_finished(ranking: Array) -> void:
    if NetworkManager.is_client():
        return
    last_minigame_ranking = ranking
    last_minigame_rewards = []
    for i in ranking.size():
        var reward: int = MINIGAME_REWARDS[mini(i, MINIGAME_REWARDS.size() - 1)]
        EconomyManager.add_coins(ranking[i], reward)
        last_minigame_rewards.append(reward)
    minigame_rewards_granted.emit(last_minigame_ranking, last_minigame_rewards)


func _set_state(new_state: int) -> void:
    state = new_state
    state_changed.emit(new_state)

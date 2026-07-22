extends Node

# Single owner of board state: tile graph and pawn positions.
# Board layout is data-driven (res://data/casino_board.json).

signal player_stepped(player_id: int, tile_id: int)
signal player_placed(player_id: int, tile_id: int)
signal route_choice_required(player_id: int, options: Array)
signal move_finished(player_id: int)
signal tile_resolved(player_id: int, tile_id: int, tile_type: String, coins_delta: int)
signal start_passed(player_id: int, bonus: int)
signal bonus_item_granted(player_id: int, item_id: String)

const BOARD_PATH := "res://data/casino_board.json"
const START_TILE := 0
const START_PASS_BONUS := 20

var tiles := {}
var positions := {}

var _moving_player := -1
var _steps_left := 0
var _moving_backward := false
var _awaiting_trophy := false
var _reverse_map := {}


func _ready() -> void:
    _load_board()


func _load_board() -> void:
    var file := FileAccess.open(BOARD_PATH, FileAccess.READ)
    var data: Dictionary = JSON.parse_string(file.get_as_text())
    for t in data["tiles"]:
        tiles[int(t["id"])] = {
            "type": String(t["type"]),
            "coins": int(t.get("coins", 0)),
            "next": t["next"].map(func(n): return int(n)),
            "ring": int(t.get("ring", -1)),
            "between": t.get("between", []),
        }
    for tile_id in tiles:
        _reverse_map[tile_id] = []
    for tile_id in tiles:
        for next_id in tiles[tile_id]["next"]:
            _reverse_map[next_id].append(tile_id)


func reset(player_ids: Array) -> void:
    positions.clear()
    for player_id in player_ids:
        positions[player_id] = START_TILE
    _moving_player = -1
    _steps_left = 0
    _moving_backward = false
    _awaiting_trophy = false


func get_tile(tile_id: int) -> Dictionary:
    return tiles[tile_id]


func begin_move(player_id: int, steps: int, backward: bool = false) -> void:
    _moving_player = player_id
    _steps_left = steps
    _moving_backward = backward
    _advance()


func choose_route(tile_id: int) -> void:
    if _moving_player == -1:
        return
    _step_to(tile_id)


func resolve_tile(player_id: int) -> void:
    var tile: Dictionary = tiles[positions[player_id]]
    var delta: int = tile["coins"]
    if tile["type"] == "bonus":
        delta = _resolve_bonus(player_id)
    if delta != 0:
        EconomyManager.add_coins(player_id, delta)
    tile_resolved.emit(player_id, positions[player_id], tile["type"], delta)


func _resolve_bonus(player_id: int) -> int:
    var roll := randf()
    if roll < 0.3:
        var item_id := ItemManager.grant_random_item(player_id)
        if item_id != "":
            bonus_item_granted.emit(player_id, item_id)
            return 0
        return 15
    elif roll < 0.75:
        return 8 + randi() % 13
    return -(5 + randi() % 8)


func _advance() -> void:
    if _steps_left <= 0:
        var finished_player := _moving_player
        _moving_player = -1
        _moving_backward = false
        move_finished.emit(finished_player)
        return
    var options: Array = (
        _reverse_map[positions[_moving_player]] if _moving_backward
        else tiles[positions[_moving_player]]["next"]
    )
    if options.size() > 1:
        route_choice_required.emit(_moving_player, options)
        return
    _step_to(options[0])


func swap_positions(player_a: int, player_b: int) -> void:
    var tile_a: int = positions[player_a]
    positions[player_a] = positions[player_b]
    positions[player_b] = tile_a
    player_placed.emit(player_a, positions[player_a])
    player_placed.emit(player_b, positions[player_b])


func push_back(player_id: int, steps: int) -> void:
    for i in steps:
        var preds: Array = _reverse_map.get(positions[player_id], [])
        if preds.is_empty():
            break
        positions[player_id] = preds[randi() % preds.size()]
        player_stepped.emit(player_id, positions[player_id])


func resume_move() -> void:
    if not _awaiting_trophy:
        return
    _awaiting_trophy = false
    _advance()


func _step_to(tile_id: int) -> void:
    positions[_moving_player] = tile_id
    _steps_left -= 1
    player_stepped.emit(_moving_player, tile_id)
    if tile_id == START_TILE and not _moving_backward:
        EconomyManager.add_coins(_moving_player, START_PASS_BONUS)
        start_passed.emit(_moving_player, START_PASS_BONUS)
    if (
        tile_id == TrophyManager.trophy_tile
        and EconomyManager.get_coins(_moving_player) >= TrophyManager.TROPHY_COST
    ):
        _awaiting_trophy = true
        TrophyManager.offer(_moving_player)
        return
    _advance()

extends Node

# Single owner of board state: tile graph and pawn positions.
# Board layout is data-driven (res://data/casino_board.json).

signal player_stepped(player_id: int, tile_id: int)
signal route_choice_required(player_id: int, options: Array)
signal move_finished(player_id: int)
signal tile_resolved(player_id: int, tile_id: int, tile_type: String, coins_delta: int)
signal start_passed(player_id: int, bonus: int)

const BOARD_PATH := "res://data/casino_board.json"
const START_TILE := 0
const START_PASS_BONUS := 20

var tiles := {}
var positions := {}

var _moving_player := -1
var _steps_left := 0
var _awaiting_trophy := false


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


func reset(player_ids: Array) -> void:
    positions.clear()
    for player_id in player_ids:
        positions[player_id] = START_TILE
    _moving_player = -1
    _steps_left = 0
    _awaiting_trophy = false


func get_tile(tile_id: int) -> Dictionary:
    return tiles[tile_id]


func begin_move(player_id: int, steps: int) -> void:
    _moving_player = player_id
    _steps_left = steps
    _advance()


func choose_route(tile_id: int) -> void:
    if _moving_player == -1:
        return
    _step_to(tile_id)


func resolve_tile(player_id: int) -> void:
    var tile: Dictionary = tiles[positions[player_id]]
    var delta: int = tile["coins"]
    if delta != 0:
        EconomyManager.add_coins(player_id, delta)
    tile_resolved.emit(player_id, positions[player_id], tile["type"], delta)


func _advance() -> void:
    if _steps_left <= 0:
        var finished_player := _moving_player
        _moving_player = -1
        move_finished.emit(finished_player)
        return
    var options: Array = tiles[positions[_moving_player]]["next"]
    if options.size() > 1:
        route_choice_required.emit(_moving_player, options)
        return
    _step_to(options[0])


func resume_move() -> void:
    if not _awaiting_trophy:
        return
    _awaiting_trophy = false
    _advance()


func _step_to(tile_id: int) -> void:
    positions[_moving_player] = tile_id
    _steps_left -= 1
    player_stepped.emit(_moving_player, tile_id)
    if tile_id == START_TILE:
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

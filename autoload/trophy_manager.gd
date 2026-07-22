extends Node

# Single owner of trophy counts and the Main Trophy location.
# One Main Trophy exists at a time; it respawns elsewhere when bought
# (GDD_TROPHIES). Cost is a prototype placeholder.

signal trophies_changed(player_id: int, count: int)
signal trophy_moved(tile_id: int)
signal trophy_offer(player_id: int, cost: int)
signal trophy_bought(player_id: int, count: int)

const TROPHY_COST := 50

var trophy_tile := -1

var _counts := {}
var _pending_player := -1


func reset(player_ids: Array) -> void:
    _counts.clear()
    for player_id in player_ids:
        _counts[player_id] = 0
        trophies_changed.emit(player_id, 0)
    _pending_player = -1
    _relocate()


func get_trophies(player_id: int) -> int:
    return _counts.get(player_id, 0)


func ranking() -> Array:
    var ids: Array = _counts.keys()
    ids.sort_custom(
        func(a, b):
            if _counts[a] != _counts[b]:
                return _counts[a] > _counts[b]
            return EconomyManager.get_coins(a) > EconomyManager.get_coins(b)
    )
    return ids


func offer(player_id: int) -> void:
    _pending_player = player_id
    trophy_offer.emit(player_id, TROPHY_COST)


func buy() -> void:
    if _pending_player == -1:
        return
    var player_id := _pending_player
    _pending_player = -1
    EconomyManager.add_coins(player_id, -TROPHY_COST)
    _counts[player_id] += 1
    trophies_changed.emit(player_id, _counts[player_id])
    trophy_bought.emit(player_id, _counts[player_id])
    _relocate()
    BoardManager.resume_move()


func skip() -> void:
    if _pending_player == -1:
        return
    _pending_player = -1
    BoardManager.resume_move()


func _relocate() -> void:
    var candidates: Array = []
    for tile_id in BoardManager.tiles:
        if tile_id != BoardManager.START_TILE and tile_id != trophy_tile:
            candidates.append(tile_id)
    trophy_tile = candidates[randi() % candidates.size()]
    trophy_moved.emit(trophy_tile)

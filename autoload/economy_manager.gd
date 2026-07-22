extends Node

# Single owner of coins. Nobody else modifies coin values (GDD coding rule 2).

signal coins_changed(player_id: int, coins: int)

var _coins := {}


func reset(player_ids: Array, starting_coins: int) -> void:
    _coins.clear()
    for player_id in player_ids:
        _coins[player_id] = starting_coins
        coins_changed.emit(player_id, starting_coins)


func add_coins(player_id: int, amount: int) -> void:
    _coins[player_id] = maxi(0, int(_coins[player_id]) + amount)
    coins_changed.emit(player_id, _coins[player_id])


func get_coins(player_id: int) -> int:
    return _coins.get(player_id, 0)


func ranking() -> Array:
    var ids: Array = _coins.keys()
    ids.sort_custom(func(a, b): return _coins[a] > _coins[b])
    return ids

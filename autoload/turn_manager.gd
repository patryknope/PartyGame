extends Node

# Single owner of turn order and the current turn.

signal turn_started(player_id: int)
signal all_turns_completed

var _order: Array = []
var _current_index := 0


func reset(player_ids: Array) -> void:
    _order = player_ids.duplicate()
    _current_index = 0


func start_round() -> void:
    _current_index = 0
    turn_started.emit(_order[0])


func current_player_id() -> int:
    return _order[_current_index]


func end_turn() -> void:
    _current_index += 1
    if _current_index >= _order.size():
        all_turns_completed.emit()
    else:
        turn_started.emit(_order[_current_index])

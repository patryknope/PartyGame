extends Node

# Casino-specific board mechanics (GDD_CASINO). Lives under
# board/casino/ per the "core does not know board specifics" rule —
# future boards get their own module. Currently: poker tables
# (video-poker on KARTY tiles). Roulette comes next.

signal poker_started(player_id: int, hand: Array)
signal poker_finished(player_id: int, hand: Array, hand_name: String, payout: int)

# Payouts per hand category (prototype placeholders).
const PAYOUTS := {0: 0, 1: 3, 2: 8, 3: 15, 4: 25, 5: 30, 6: 40, 7: 60, 8: 100}

var _deck: Array = []
var _pending_player := -1
var _pending_hand: Array = []


func start_poker(player_id: int) -> void:
    _deck = PlayingCards.new_deck()
    _pending_player = player_id
    _pending_hand = []
    for i in 5:
        _pending_hand.append(_deck.pop_back())
    poker_started.emit(player_id, _pending_hand.duplicate(true))


func redraw(held_indexes: Array) -> void:
    if _pending_player == -1:
        return
    var player_id := _pending_player
    _pending_player = -1
    for i in 5:
        if not held_indexes.has(i):
            _pending_hand[i] = _deck.pop_back()
    var result := PlayingCards.evaluate(_pending_hand)
    var payout: int = PAYOUTS[result["category"]]
    if payout > 0:
        EconomyManager.add_coins(player_id, payout)
    poker_finished.emit(player_id, _pending_hand.duplicate(true), result["name"], payout)


func cancel() -> void:
    _pending_player = -1

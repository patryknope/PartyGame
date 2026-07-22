extends Node

# Single owner of player identity (id, name, color).
# Positions live in BoardManager, coins in EconomyManager.

const PLAYER_COLORS: Array[Color] = [
    Color(0.90, 0.28, 0.28),
    Color(0.28, 0.52, 0.93),
    Color(0.30, 0.78, 0.38),
    Color(0.94, 0.79, 0.22),
]
const PLAYER_NAMES: Array[String] = ["Czerwony", "Niebieski", "Zielony", "Zolty"]

var players: Array = []


func setup_players(count: int) -> void:
    players.clear()
    for i in count:
        players.append({"id": i, "name": PLAYER_NAMES[i], "color": PLAYER_COLORS[i]})


func get_player(player_id: int) -> Dictionary:
    return players[player_id]


func get_player_ids() -> Array:
    return players.map(func(p): return p["id"])


func player_count() -> int:
    return players.size()

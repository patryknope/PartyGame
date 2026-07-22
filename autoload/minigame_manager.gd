extends Node

# Owns the minigame registry, selection and result reporting.

signal minigame_finished(ranking: Array)

const MINIGAMES: Array = [
    {
        "id": "color_chaos",
        "name": "Kolorowy Chaos",
        "script": "res://minigames/color_chaos/color_chaos.gd",
        "rules": "Na arenie pojawia sie kolor docelowy.\nStan na polu w tym kolorze zanim minie czas!\nKto stoi na zlym kolorze — odpada.\nOstatni gracz na arenie wygrywa.",
        "min_players": 2,
        "max_players": 4,
    },
]

var current: Dictionary = {}


func select_minigame(player_count: int) -> void:
    var pool := MINIGAMES.filter(
        func(m): return player_count >= m["min_players"] and player_count <= m["max_players"]
    )
    current = pool[randi() % pool.size()]


func instantiate_current() -> Control:
    return load(current["script"]).new()


func report_finished(ranking: Array) -> void:
    minigame_finished.emit(ranking)

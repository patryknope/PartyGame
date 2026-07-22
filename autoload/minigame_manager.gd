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
        "online": true,
    },
    {
        "id": "hot_potato",
        "name": "Goracy Ziemniak",
        "script": "res://minigames/hot_potato/hot_potato.gd",
        "rules": "Jeden z graczy trzyma bombe z ukrytym lontem.\nDotknij innego gracza, zeby mu ja przekazac!\nGdy bomba wybuchnie, jej posiadacz odpada.\nOstatni gracz na arenie wygrywa.",
        "min_players": 2,
        "max_players": 4,
    },
    {
        "id": "poker_draw",
        "name": "Poker Draw",
        "script": "res://minigames/poker_draw/poker_draw.gd",
        "rules": "Kazdy gracz dostaje 5 kart i jedna wymiane.\nKliknij karty, ktore zatrzymujesz, reszta idzie do wymiany.\nNajlepszy uklad pokerowy wygrywa!",
        "min_players": 2,
        "max_players": 4,
    },
    {
        "id": "crown_steal",
        "name": "Kradziez Korony",
        "script": "res://minigames/crown_steal/crown_steal.gd",
        "rules": "Na srodku areny lezy korona.\nPodnies ja i uciekaj — czas noszenia to punkty!\nDotknij posiadacza korony, zeby mu ja ukrasc.\nWygrywa ten, kto nosil korone najdluzej.",
        "min_players": 2,
        "max_players": 4,
    },
]

var current: Dictionary = {}


func select_minigame(player_count: int, online: bool = false) -> void:
    var pool := MINIGAMES.filter(
        func(m):
            if player_count < m["min_players"] or player_count > m["max_players"]:
                return false
            return not online or m.get("online", false)
    )
    current = pool[randi() % pool.size()]


func instantiate_current() -> Control:
    return load(current["script"]).new()


func report_finished(ranking: Array) -> void:
    minigame_finished.emit(ranking)

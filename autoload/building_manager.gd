extends Node

# Single owner of buildings. Prototype implements the Economic
# Building only (GDD_BUILDINGS): permanent, one per player, passive
# income at the start of the owner's turn. Upgrades use levels 1-3 as
# a stand-in for the Talent system; costs are placeholders.

signal building_changed(tile_id: int, owner_id: int, level: int)
signal build_offer(player_id: int, tile_id: int, cost: int)
signal upgrade_offer(player_id: int, tile_id: int, cost: int, next_level: int)
signal income_granted(player_id: int, amount: int)
signal buildings_reset

const BUILD_COST := 40
const UPGRADE_COSTS: Array[int] = [30, 50]
const INCOME_PER_LEVEL := 5
const MAX_LEVEL := 3

var buildings := {}

var _pending := {}


func _ready() -> void:
    TurnManager.turn_started.connect(_on_turn_started)


func reset(_player_ids: Array) -> void:
    buildings.clear()
    _pending = {}
    buildings_reset.emit()


func consider_offer(player_id: int, tile_id: int) -> void:
    var coins := EconomyManager.get_coins(player_id)
    if buildings.has(tile_id):
        var building: Dictionary = buildings[tile_id]
        if building["owner"] != player_id or building["level"] >= MAX_LEVEL:
            return
        var cost: int = UPGRADE_COSTS[building["level"] - 1]
        if coins < cost:
            return
        _pending = {"player_id": player_id, "tile_id": tile_id, "mode": "upgrade", "cost": cost}
        upgrade_offer.emit(player_id, tile_id, cost, building["level"] + 1)
        return
    if BoardManager.get_tile(tile_id)["type"] != "neutral":
        return
    if _owns_economic(player_id) or coins < BUILD_COST:
        return
    _pending = {"player_id": player_id, "tile_id": tile_id, "mode": "build", "cost": BUILD_COST}
    build_offer.emit(player_id, tile_id, BUILD_COST)


func confirm() -> void:
    if _pending.is_empty():
        return
    var pending := _pending
    _pending = {}
    EconomyManager.add_coins(pending["player_id"], -int(pending["cost"]))
    if pending["mode"] == "build":
        buildings[pending["tile_id"]] = {"owner": pending["player_id"], "level": 1}
    else:
        buildings[pending["tile_id"]]["level"] += 1
    var building: Dictionary = buildings[pending["tile_id"]]
    building_changed.emit(pending["tile_id"], building["owner"], building["level"])


func skip() -> void:
    _pending = {}


func _owns_economic(player_id: int) -> bool:
    for tile_id in buildings:
        if buildings[tile_id]["owner"] == player_id:
            return true
    return false


func _on_turn_started(player_id: int) -> void:
    if NetworkManager.is_client():
        return
    var amount := 0
    for tile_id in buildings:
        if buildings[tile_id]["owner"] == player_id:
            amount += buildings[tile_id]["level"] * INCOME_PER_LEVEL
    if amount > 0:
        EconomyManager.add_coins(player_id, amount)
        income_granted.emit(player_id, amount)

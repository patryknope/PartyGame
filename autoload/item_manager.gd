extends Node

# Single owner of item inventories, shields and traps.
# Canon item names from GDD_ITEMS; prototype implements a subset and
# simplifies Trap to "placed on your current tile". Prices are
# rarity-tier placeholders (open question in the GDD).

signal inventory_changed(player_id: int, items: Array)
signal shop_opened(player_id: int, offers: Array)
signal item_used(player_id: int, item_id: String, target_id: int)
signal item_blocked(target_id: int)
signal trap_triggered(victim_id: int, owner_id: int, coins_lost: int)

const MAX_SLOTS := 8
const TRAP_PENALTY := 10
const ROCKET_PENALTY := 15
const PUNCH_PENALTY := 12
const PUNCH_PUSHBACK := 3

const POOL: Array = [
    {"id": "extra_roll", "name": "Extra Roll", "kind": "utility", "price": 10,
     "desc": "Rzuc dwa razy i wybierz wynik"},
    {"id": "shield", "name": "Shield", "kind": "utility", "price": 10,
     "desc": "Blokuje nastepny wrogi efekt"},
    {"id": "loaded_dice", "name": "Loaded Dice", "kind": "utility", "price": 35,
     "desc": "Wybierz dokladny wynik ruchu"},
    {"id": "swap", "name": "Swap", "kind": "utility", "price": 50,
     "desc": "Zamien sie pozycja z graczem"},
    {"id": "reverse", "name": "Reverse", "kind": "utility", "price": 15,
     "desc": "Nastepny ruch wykonujesz do tylu"},
    {"id": "copy_cat", "name": "Copy Cat", "kind": "utility", "price": 15,
     "desc": "Uzyj wyniku rzutu poprzedniego gracza"},
    {"id": "trap", "name": "Trap", "kind": "warfare", "price": 10,
     "desc": "Pulapka na twoim polu (-%d)" % TRAP_PENALTY},
    {"id": "rocket", "name": "Rocket", "kind": "warfare", "price": 20,
     "desc": "Wybrany gracz traci %d monet" % ROCKET_PENALTY},
    {"id": "magnet", "name": "Magnet", "kind": "warfare", "price": 20,
     "desc": "Kradnie 5-15 monet graczowi"},
    {"id": "punch", "name": "Punch", "kind": "warfare", "price": 15,
     "desc": "Cios: -%d monet i %d pola do tylu" % [PUNCH_PENALTY, PUNCH_PUSHBACK]},
]

var _inventories := {}
var _shields := {}
var _traps := {}
var _reverse := {}


func reset(player_ids: Array) -> void:
    _inventories.clear()
    _shields.clear()
    _traps.clear()
    _reverse.clear()
    for player_id in player_ids:
        _inventories[player_id] = []
        inventory_changed.emit(player_id, [])


func get_items(player_id: int) -> Array:
    return _inventories.get(player_id, [])


func get_definition(item_id: String) -> Dictionary:
    for item in POOL:
        if item["id"] == item_id:
            return item
    return {}


func open_shop(player_id: int) -> void:
    var utilities := POOL.filter(func(i): return i["kind"] == "utility")
    var warfare := POOL.filter(func(i): return i["kind"] == "warfare")
    utilities.shuffle()
    warfare.shuffle()
    var offers: Array = [utilities[0], warfare[0]]
    var rest := POOL.filter(func(i): return not offers.has(i))
    offers.append(rest.pick_random())
    shop_opened.emit(player_id, offers)


func buy(player_id: int, item_id: String) -> bool:
    var item := get_definition(item_id)
    if item.is_empty():
        return false
    if _inventories[player_id].size() >= MAX_SLOTS:
        return false
    if EconomyManager.get_coins(player_id) < int(item["price"]):
        return false
    EconomyManager.add_coins(player_id, -int(item["price"]))
    _inventories[player_id].append(item_id)
    inventory_changed.emit(player_id, _inventories[player_id])
    return true


func use_item(player_id: int, item_id: String, target_id: int = -1) -> void:
    if not _inventories[player_id].has(item_id):
        return
    _inventories[player_id].erase(item_id)
    inventory_changed.emit(player_id, _inventories[player_id])
    match item_id:
        "shield":
            _shields[player_id] = true
        "reverse":
            _reverse[player_id] = true
        "trap":
            _traps[BoardManager.positions[player_id]] = player_id
        "rocket":
            if _consume_shield(target_id):
                return
            EconomyManager.add_coins(target_id, -ROCKET_PENALTY)
        "punch":
            if _consume_shield(target_id):
                return
            EconomyManager.add_coins(target_id, -PUNCH_PENALTY)
            BoardManager.push_back(target_id, PUNCH_PUSHBACK)
        "magnet":
            if _consume_shield(target_id):
                return
            var amount := mini(5 + randi() % 11, EconomyManager.get_coins(target_id))
            EconomyManager.add_coins(target_id, -amount)
            EconomyManager.add_coins(player_id, amount)
        "swap":
            BoardManager.swap_positions(player_id, target_id)
    item_used.emit(player_id, item_id, target_id)


func consume_reverse(player_id: int) -> bool:
    if _reverse.get(player_id, false):
        _reverse.erase(player_id)
        return true
    return false


func grant_random_item(player_id: int) -> String:
    if _inventories[player_id].size() >= MAX_SLOTS:
        return ""
    var affordable := POOL.filter(func(i): return int(i["price"]) <= 20)
    var item: Dictionary = affordable.pick_random()
    _inventories[player_id].append(item["id"])
    inventory_changed.emit(player_id, _inventories[player_id])
    return item["id"]


func trigger_trap(victim_id: int, tile_id: int) -> void:
    if not _traps.has(tile_id):
        return
    var owner_id: int = _traps[tile_id]
    if owner_id == victim_id:
        return
    _traps.erase(tile_id)
    if _consume_shield(victim_id):
        return
    EconomyManager.add_coins(victim_id, -TRAP_PENALTY)
    trap_triggered.emit(victim_id, owner_id, TRAP_PENALTY)


func _consume_shield(target_id: int) -> bool:
    if _shields.get(target_id, false):
        _shields[target_id] = false
        item_blocked.emit(target_id)
        return true
    return false

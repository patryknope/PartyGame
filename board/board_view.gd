extends Control

# Pure presentation of the board: landscape, road, tiles, bear pawns
# and movement animation. Reads state from BoardManager, never modifies it.

const TILE_DIAMETER := 48.0
const START_DIAMETER := 64.0
const RING_CENTER := Vector2(640, 342)
const RING_RADIUS := Vector2(470, 222)
const ROAD_FILL := Color(0.88, 0.78, 0.6)
const ROAD_BORDER := Color(0.56, 0.43, 0.29)
const TYPE_COLORS := {
    "start": Color(0.95, 0.78, 0.3),
    "blue": Color(0.27, 0.52, 0.9),
    "red": Color(0.86, 0.3, 0.32),
    "neutral": Color(0.55, 0.56, 0.62),
    "shop": Color(0.62, 0.4, 0.85),
    "cards": Color(0.15, 0.5, 0.44),
}
const TYPE_ICONS := {
    "start": "GO", "blue": "+10", "red": "-5", "neutral": "", "shop": "SKLEP", "cards": "KARTY",
}
const PAWN_OFFSETS: Array[Vector2] = [
    Vector2(-24, 4), Vector2(24, 4), Vector2(-9, 18), Vector2(9, 18),
]

var tile_positions := {}
var pawns := {}

var _anim_queue: Array = []
var _animating := false
var _active_player := -1
var _road_layer: Control
var _trophy_marker: Node2D
var _building_markers := {}


class TrophyMarker extends Node2D:
    func _ready() -> void:
        var bob := create_tween().set_loops()
        bob.tween_property(self, "position:y", position.y - 6.0, 0.6)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        bob.tween_property(self, "position:y", position.y, 0.6)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        var pulse := create_tween().set_loops()
        pulse.tween_property(self, "scale", Vector2(1.18, 1.18), 0.6)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        pulse.tween_property(self, "scale", Vector2.ONE, 0.6)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    func _draw() -> void:
        var gold := Color(0.99, 0.83, 0.28)
        var points := PackedVector2Array()
        for i in 10:
            var radius := 15.0 if i % 2 == 0 else 6.5
            var angle := -PI / 2.0 + TAU * i / 10.0
            points.append(Vector2(cos(angle), sin(angle)) * radius)
        draw_colored_polygon(points, gold)
        draw_circle(Vector2.ZERO, 4.5, Color(1, 1, 1, 0.85))


class BuildingMarker extends Node2D:
    var owner_color := Color.WHITE
    var level := 1

    func set_level(new_level: int) -> void:
        level = new_level
        queue_redraw()
        var pop := create_tween()
        pop.tween_property(self, "scale", Vector2(1.3, 1.3), 0.12)
        pop.tween_property(self, "scale", Vector2.ONE, 0.12)

    func _draw() -> void:
        draw_rect(Rect2(-10, -10, 20, 12), owner_color.darkened(0.1))
        draw_colored_polygon(
            PackedVector2Array([Vector2(-13, -10), Vector2(0, -22), Vector2(13, -10)]),
            Color(0.55, 0.34, 0.2)
        )
        draw_rect(Rect2(-3, -6, 6, 8), Color(0.35, 0.22, 0.14))
        for i in level:
            draw_circle(Vector2(-6.0 + i * 6.0, 6.5), 2.2, Color(0.95, 0.78, 0.3))


func _ready() -> void:
    BoardManager.player_stepped.connect(_on_player_stepped)
    BoardManager.player_placed.connect(_on_player_placed)
    BoardManager.tile_resolved.connect(_on_tile_resolved)
    BoardManager.start_passed.connect(_on_start_passed)
    TurnManager.turn_started.connect(_on_turn_started)
    TrophyManager.trophy_moved.connect(_on_trophy_moved)
    TrophyManager.trophy_bought.connect(_on_trophy_bought)
    ItemManager.trap_triggered.connect(_on_trap_triggered)
    ItemManager.item_used.connect(_on_item_used)
    ItemManager.item_blocked.connect(_on_item_blocked)
    BuildingManager.building_changed.connect(_on_building_changed)
    BuildingManager.buildings_reset.connect(_on_buildings_reset)
    BuildingManager.income_granted.connect(_on_income_granted)
    CasinoManager.poker_finished.connect(_on_poker_finished)
    GameManager.jackpot_result.connect(_on_jackpot_result)

    var scenery := Scenery.new()
    scenery.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(scenery)

    _road_layer = Control.new()
    _road_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
    _road_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(_road_layer)

    _build_tiles()
    _road_layer.draw.connect(_draw_roads)
    _road_layer.queue_redraw()


func _build_tiles() -> void:
    for tile_id in BoardManager.tiles:
        tile_positions[tile_id] = _tile_center(BoardManager.tiles[tile_id])
    for tile_id in BoardManager.tiles:
        var tile: Dictionary = BoardManager.tiles[tile_id]
        var diameter := START_DIAMETER if tile["type"] == "start" else TILE_DIAMETER
        var node := Panel.new()
        var color: Color = TYPE_COLORS[tile["type"]]
        node.add_theme_stylebox_override(
            "panel", UiStyle.circle(color, 4, Color(1, 1, 1, 0.9), 4)
        )
        node.size = Vector2(diameter, diameter)
        node.position = tile_positions[tile_id] - node.size / 2.0
        add_child(node)

        var icon := Label.new()
        icon.text = TYPE_ICONS[tile["type"]]
        icon.set_anchors_preset(Control.PRESET_FULL_RECT)
        icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        icon.add_theme_font_size_override("font_size", 18 if tile["type"] == "start" else 15)
        icon.add_theme_color_override("font_color", Color(1, 1, 1, 0.95))
        icon.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.4))
        icon.add_theme_constant_override("outline_size", 4)
        node.add_child(icon)


func _ring_points() -> PackedVector2Array:
    var by_ring := {}
    for tile_id in BoardManager.tiles:
        var ring: int = BoardManager.tiles[tile_id]["ring"]
        if ring >= 0:
            by_ring[ring] = tile_positions[tile_id]
    var points := PackedVector2Array()
    for ring in range(by_ring.size()):
        points.append(by_ring[ring])
    points.append(by_ring[0])
    return points


func _shortcut_points() -> PackedVector2Array:
    var shortcut_tiles: Array = []
    for tile_id in BoardManager.tiles:
        if BoardManager.tiles[tile_id]["ring"] < 0:
            shortcut_tiles.append(tile_id)
    if shortcut_tiles.is_empty():
        return PackedVector2Array()
    shortcut_tiles.sort_custom(
        func(a, b): return BoardManager.tiles[a]["between"][2] < BoardManager.tiles[b]["between"][2]
    )
    var first: Dictionary = BoardManager.tiles[shortcut_tiles[0]]
    var points := PackedVector2Array()
    points.append(tile_positions[int(first["between"][0])])
    for tile_id in shortcut_tiles:
        points.append(tile_positions[tile_id])
    points.append(tile_positions[int(first["between"][1])])
    return points


func _draw_roads() -> void:
    var ring := _ring_points()
    var shortcut := _shortcut_points()
    _road_layer.draw_polyline(ring, ROAD_BORDER, 42, true)
    if shortcut.size() > 0:
        _road_layer.draw_polyline(shortcut, ROAD_BORDER, 34, true)
    _road_layer.draw_polyline(ring, ROAD_FILL, 32, true)
    if shortcut.size() > 0:
        _road_layer.draw_polyline(shortcut, ROAD_FILL.darkened(0.06), 25, true)
    _draw_dashes(ring)
    _draw_dashes(shortcut)


func _draw_dashes(points: PackedVector2Array) -> void:
    for i in range(points.size() - 1):
        var from := points[i]
        var to := points[i + 1]
        var length := from.distance_to(to)
        var direction := (to - from) / length
        var travelled := 8.0
        while travelled + 10.0 < length:
            _road_layer.draw_line(
                from + direction * travelled,
                from + direction * (travelled + 10.0),
                Color(1, 1, 1, 0.7),
                3.0,
                true
            )
            travelled += 26.0


func _tile_center(tile: Dictionary) -> Vector2:
    if tile["ring"] >= 0:
        var angle: float = -PI / 2.0 + TAU * int(tile["ring"]) / 20.0
        return RING_CENTER + Vector2(cos(angle) * RING_RADIUS.x, sin(angle) * RING_RADIUS.y)
    var between: Array = tile["between"]
    var from_tile: Dictionary = BoardManager.tiles[int(between[0])]
    var to_tile: Dictionary = BoardManager.tiles[int(between[1])]
    var t := float(between[2]) / float(between[3])
    return _tile_center(from_tile).lerp(_tile_center(to_tile), t)


func setup_pawns() -> void:
    for pawn in pawns.values():
        pawn.queue_free()
    pawns.clear()
    _anim_queue.clear()
    _animating = false
    _active_player = -1
    for player in PlayerManager.players:
        var bear := BearCharacter.new()
        bear.base_color = player["color"]
        bear.accessory = player["id"]
        bear.scale = Vector2(0.85, 0.85)
        bear.position = _pawn_target(player["id"], BoardManager.START_TILE)
        add_child(bear)
        pawns[player["id"]] = bear


func _pawn_target(player_id: int, tile_id: int) -> Vector2:
    return tile_positions[tile_id] + PAWN_OFFSETS[player_id]


func _on_trophy_moved(tile_id: int) -> void:
    if _trophy_marker != null:
        _trophy_marker.queue_free()
    if not tile_positions.has(tile_id):
        return
    _trophy_marker = TrophyMarker.new()
    _trophy_marker.position = tile_positions[tile_id] - Vector2(0, 42)
    add_child(_trophy_marker)


func _on_turn_started(player_id: int) -> void:
    if pawns.has(_active_player):
        pawns[_active_player].highlight = false
    _active_player = player_id
    if pawns.has(player_id):
        pawns[player_id].highlight = true


func _on_player_stepped(player_id: int, tile_id: int) -> void:
    _anim_queue.append([player_id, tile_id])
    if not _animating:
        _play_next()


func _play_next() -> void:
    if _anim_queue.is_empty():
        _animating = false
        return
    _animating = true
    var step: Array = _anim_queue.pop_front()
    var bear: BearCharacter = pawns[step[0]]
    var tween := bear.hop_to(_pawn_target(step[0], step[1]), 0.26)
    tween.finished.connect(_play_next)


func _on_player_placed(player_id: int, tile_id: int) -> void:
    if pawns.has(player_id):
        pawns[player_id].hop_to(_pawn_target(player_id, tile_id), 0.35)


func _popup(player_id: int, text: String, color: Color) -> void:
    if not pawns.has(player_id):
        return
    var label := Label.new()
    label.text = text
    label.position = pawns[player_id].position + Vector2(-40, -86)
    label.size = Vector2(80, 26)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    UiStyle.title_look(label, 20, color)
    add_child(label)
    var tween := create_tween()
    tween.set_parallel()
    tween.tween_property(label, "position:y", label.position.y - 34.0, 0.9)
    tween.tween_property(label, "modulate:a", 0.0, 0.9).set_delay(0.35)
    tween.chain().tween_callback(label.queue_free)


func _emote(player_id: int, kind: String) -> void:
    if pawns.has(player_id):
        pawns[player_id].show_emote(kind)


func _on_tile_resolved(player_id: int, _tile_id: int, tile_type: String, coins_delta: int) -> void:
    if coins_delta > 0:
        _popup(player_id, "+%d" % coins_delta, UiStyle.GOLD)
        _emote(player_id, "happy")
    elif coins_delta < 0:
        _popup(player_id, str(coins_delta), Color(0.95, 0.4, 0.4))
        _emote(player_id, "sad")
    elif tile_type == "shop":
        _emote(player_id, "coin")


func _on_start_passed(player_id: int, bonus: int) -> void:
    _popup(player_id, "+%d" % bonus, UiStyle.GOLD)
    _emote(player_id, "coin")


func _on_trophy_bought(player_id: int, _count: int) -> void:
    _popup(player_id, "TROFEUM!", UiStyle.GOLD)
    _emote(player_id, "star")


func _on_trap_triggered(victim_id: int, _owner_id: int, coins_lost: int) -> void:
    _popup(victim_id, "-%d" % coins_lost, Color(0.95, 0.4, 0.4))
    _emote(victim_id, "shock")


func _on_item_used(player_id: int, item_id: String, target_id: int) -> void:
    if item_id in ["rocket", "magnet"] and target_id >= 0:
        _emote(target_id, "angry")
        _emote(player_id, "happy")
    elif item_id == "shield":
        _emote(player_id, "happy")


func _on_item_blocked(target_id: int) -> void:
    _popup(target_id, "BLOK!", Color(0.6, 0.85, 1.0))
    _emote(target_id, "happy")


func _on_income_granted(player_id: int, amount: int) -> void:
    _popup(player_id, "+%d" % amount, UiStyle.GOLD)
    _emote(player_id, "coin")


func _on_building_changed(tile_id: int, owner_id: int, level: int) -> void:
    if _building_markers.has(tile_id):
        _building_markers[tile_id].set_level(level)
        return
    var marker := BuildingMarker.new()
    marker.owner_color = PlayerManager.get_player(owner_id)["color"]
    marker.level = level
    marker.position = tile_positions[tile_id] + Vector2(26, -30)
    add_child(marker)
    _building_markers[tile_id] = marker


func _on_buildings_reset() -> void:
    for marker in _building_markers.values():
        marker.queue_free()
    _building_markers.clear()


func _on_poker_finished(player_id: int, _hand: Array, hand_name: String, payout: int) -> void:
    if payout > 0:
        _popup(player_id, "%s +%d" % [hand_name, payout], UiStyle.GOLD)
        _emote(player_id, "star" if payout >= 25 else "happy")
    else:
        _popup(player_id, hand_name, Color(0.8, 0.8, 0.85))
        _emote(player_id, "sad")


func _on_jackpot_result(player_id: int, kind: String, value: int) -> void:
    match kind:
        "jackpot":
            _popup(player_id, "JACKPOT +%d" % value, UiStyle.GOLD)
            _emote(player_id, "star")
        "extra_roll":
            _popup(player_id, "EXTRA RZUT!", UiStyle.GOLD)
            _emote(player_id, "happy")
        "bust":
            _popup(player_id, "BUST -%d" % value, Color(0.95, 0.4, 0.4))
            _emote(player_id, "shock")

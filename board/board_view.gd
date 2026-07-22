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
}
const TYPE_ICONS := {"start": "GO", "blue": "+10", "red": "-5", "neutral": ""}
const PAWN_OFFSETS: Array[Vector2] = [
    Vector2(-24, 4), Vector2(24, 4), Vector2(-9, 18), Vector2(9, 18),
]

var tile_positions := {}
var pawns := {}

var _anim_queue: Array = []
var _animating := false
var _active_player := -1
var _road_layer: Control


func _ready() -> void:
    BoardManager.player_stepped.connect(_on_player_stepped)
    TurnManager.turn_started.connect(_on_turn_started)

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
        bear.scale = Vector2(0.85, 0.85)
        bear.position = _pawn_target(player["id"], BoardManager.START_TILE)
        add_child(bear)
        pawns[player["id"]] = bear


func _pawn_target(player_id: int, tile_id: int) -> Vector2:
    return tile_positions[tile_id] + PAWN_OFFSETS[player_id]


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

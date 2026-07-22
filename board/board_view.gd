extends Control

# Pure presentation of the board: tiles, connections, pawns and
# movement animation. Reads state from BoardManager, never modifies it.

const TILE_DIAMETER := 62.0
const START_DIAMETER := 78.0
const PAWN_DIAMETER := 28.0
const RING_CENTER := Vector2(640, 342)
const RING_RADIUS := Vector2(470, 222)
const TYPE_COLORS := {
    "start": Color(0.95, 0.78, 0.3),
    "blue": Color(0.27, 0.52, 0.9),
    "red": Color(0.86, 0.3, 0.32),
    "neutral": Color(0.42, 0.44, 0.52),
}
const TYPE_ICONS := {"start": "GO", "blue": "+10", "red": "-5", "neutral": ""}
const PAWN_OFFSETS: Array[Vector2] = [
    Vector2(-17, -17), Vector2(17, -17), Vector2(-17, 17), Vector2(17, 17),
]

var tile_positions := {}
var pawns := {}

var _anim_queue: Array = []
var _animating := false
var _active_pawn_tween: Tween
var _active_player := -1
var _felt: Panel


func _ready() -> void:
    BoardManager.player_stepped.connect(_on_player_stepped)
    TurnManager.turn_started.connect(_on_turn_started)
    _build_table()
    _build_tiles()
    _felt.draw.connect(_draw_connections)
    _felt.queue_redraw()


func _build_table() -> void:
    _felt = Panel.new()
    _felt.add_theme_stylebox_override(
        "panel", UiStyle.flat(UiStyle.FELT_LIGHT, 60, 8, Color(0.3, 0.2, 0.1), 14)
    )
    _felt.position = Vector2(90, 70)
    _felt.size = Vector2(1100, 560)
    add_child(_felt)

    var watermark := Label.new()
    watermark.text = "CASINO"
    watermark.set_anchors_preset(Control.PRESET_FULL_RECT)
    watermark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    watermark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    watermark.add_theme_font_size_override("font_size", 110)
    watermark.add_theme_color_override("font_color", Color(1, 1, 1, 0.05))
    _felt.add_child(watermark)


func _build_tiles() -> void:
    for tile_id in BoardManager.tiles:
        tile_positions[tile_id] = _tile_center(BoardManager.tiles[tile_id])
    for tile_id in BoardManager.tiles:
        var tile: Dictionary = BoardManager.tiles[tile_id]
        var diameter := START_DIAMETER if tile["type"] == "start" else TILE_DIAMETER
        var node := Panel.new()
        var color: Color = TYPE_COLORS[tile["type"]]
        node.add_theme_stylebox_override(
            "panel", UiStyle.circle(color, 4, color.lightened(0.45), 6)
        )
        node.size = Vector2(diameter, diameter)
        node.position = tile_positions[tile_id] - node.size / 2.0
        add_child(node)

        var icon := Label.new()
        icon.text = TYPE_ICONS[tile["type"]]
        icon.set_anchors_preset(Control.PRESET_FULL_RECT)
        icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
        icon.add_theme_font_size_override("font_size", 20 if tile["type"] == "start" else 17)
        icon.add_theme_color_override("font_color", Color(1, 1, 1, 0.95))
        icon.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.4))
        icon.add_theme_constant_override("outline_size", 4)
        node.add_child(icon)


func _draw_connections() -> void:
    for tile_id in BoardManager.tiles:
        for next_id in BoardManager.tiles[tile_id]["next"]:
            _felt.draw_line(
                tile_positions[tile_id] - _felt.position,
                tile_positions[int(next_id)] - _felt.position,
                Color(1, 1, 1, 0.22),
                7.0,
                true
            )


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
    if _active_pawn_tween != null:
        _active_pawn_tween.kill()
        _active_pawn_tween = null
    for player in PlayerManager.players:
        var pawn := Panel.new()
        pawn.add_theme_stylebox_override(
            "panel", UiStyle.circle(player["color"], 3, Color(1, 1, 1, 0.9), 5)
        )
        pawn.size = Vector2(PAWN_DIAMETER, PAWN_DIAMETER)
        pawn.pivot_offset = pawn.size / 2.0
        pawn.position = _pawn_target(player["id"], BoardManager.START_TILE)
        add_child(pawn)
        pawns[player["id"]] = pawn


func _pawn_target(player_id: int, tile_id: int) -> Vector2:
    return tile_positions[tile_id] + PAWN_OFFSETS[player_id] - Vector2(PAWN_DIAMETER, PAWN_DIAMETER) / 2.0


func _on_turn_started(player_id: int) -> void:
    if _active_pawn_tween != null:
        _active_pawn_tween.kill()
    if pawns.has(_active_player):
        pawns[_active_player].scale = Vector2.ONE
    _active_player = player_id
    if not pawns.has(player_id):
        return
    var pawn: Panel = pawns[player_id]
    _active_pawn_tween = create_tween().set_loops()
    _active_pawn_tween.tween_property(pawn, "scale", Vector2(1.25, 1.25), 0.45)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    _active_pawn_tween.tween_property(pawn, "scale", Vector2.ONE, 0.45)\
        .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


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
    var pawn: Panel = pawns[step[0]]
    var tween := create_tween()
    tween.tween_property(pawn, "position", _pawn_target(step[0], step[1]), 0.22)\
        .set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.finished.connect(_play_next)

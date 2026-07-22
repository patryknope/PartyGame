extends Control

# Pure presentation of the board: draws tiles, pawns and movement
# animations. Reads state from BoardManager, never modifies it.

const TILE_SIZE := Vector2(54, 54)
const PAWN_SIZE := Vector2(20, 20)
const RING_CENTER := Vector2(640, 350)
const RING_RADIUS := Vector2(470, 235)
const TYPE_COLORS := {
    "start": Color(0.95, 0.78, 0.2),
    "blue": Color(0.3, 0.55, 0.9),
    "red": Color(0.85, 0.32, 0.32),
    "neutral": Color(0.5, 0.5, 0.58),
}
const PAWN_OFFSETS: Array[Vector2] = [
    Vector2(-13, -13), Vector2(-7, -13), Vector2(-13, -7), Vector2(-7, -7),
]

var tile_positions := {}
var pawns := {}

var _anim_queue: Array = []
var _animating := false


func _ready() -> void:
    BoardManager.player_stepped.connect(_on_player_stepped)
    _build_tiles()


func _build_tiles() -> void:
    for tile_id in BoardManager.tiles:
        var tile: Dictionary = BoardManager.tiles[tile_id]
        tile_positions[tile_id] = _tile_center(tile)
    for tile_id in BoardManager.tiles:
        var tile: Dictionary = BoardManager.tiles[tile_id]
        var rect := ColorRect.new()
        rect.color = TYPE_COLORS[tile["type"]]
        rect.size = TILE_SIZE
        rect.position = tile_positions[tile_id] - TILE_SIZE / 2.0
        add_child(rect)
        if tile["type"] == "start":
            var label := Label.new()
            label.text = "START"
            label.add_theme_font_size_override("font_size", 12)
            label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
            label.position = Vector2(4, 18)
            rect.add_child(label)


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
    for player in PlayerManager.players:
        var pawn := ColorRect.new()
        pawn.color = player["color"]
        pawn.size = PAWN_SIZE
        pawn.position = _pawn_target(player["id"], BoardManager.START_TILE)
        add_child(pawn)
        pawns[player["id"]] = pawn


func _pawn_target(player_id: int, tile_id: int) -> Vector2:
    return tile_positions[tile_id] + PAWN_OFFSETS[player_id] * 1.6


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
    var pawn: ColorRect = pawns[step[0]]
    var tween := create_tween()
    tween.tween_property(pawn, "position", _pawn_target(step[0], step[1]), 0.22)
    tween.finished.connect(_play_next)

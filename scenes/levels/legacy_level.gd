extends GodotLevel
class_name LegacyLevel

var brick_scene: PackedScene = preload("res://scenes/objects/brick.tscn")
var movable_brick_scene: PackedScene = preload("res://scenes/objects/movable_brick.tscn")
var filter_brick_scene: PackedScene = preload("res://scenes/objects/filter_brick.tscn")
var locked_brick_scene: PackedScene = preload("res://scenes/objects/locked_brick.tscn")
var spike_scene: PackedScene = preload("res://scenes/objects/spikes.tscn")
var powerup_telekinesis_scene: PackedScene = preload("res://scenes/objects/powerup_telekinesis.tscn")
var powerup_link_scene: PackedScene = preload("res://scenes/objects/powerup_link.tscn")
var powerup_sprint_scene: PackedScene = preload("res://scenes/objects/powerup_sprint.tscn")
var key_scene: PackedScene = preload("res://scenes/objects/key.tscn")
var warp_scene: PackedScene = preload("res://scenes/objects/warp.tscn")
var switch_scene: PackedScene = preload("res://scenes/objects/switch.tscn")
var level_width: int = Globals.LEVEL_WIDTH;
var level_height: int = Globals.LEVEL_HEIGHT;
var tile_size: int = Globals.TILE_SIZE;
var projectile_direction: Vector2 = Vector2.ZERO
var level_structure: Array[int] = []

var intSceneMap: Dictionary = {
    1: movable_brick_scene,
    2: brick_scene,
    3: filter_brick_scene,
    4: spike_scene,
    5: locked_brick_scene,
    6: key_scene,
    7: warp_scene,
    # 8 is a conditional brick_scene based on progression flags
    9: powerup_telekinesis_scene,
    10: powerup_link_scene,
    11: powerup_sprint_scene,
    13: switch_scene
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    super._ready()
    var player_bounds: Rect2 = Rect2(%Player.position - %Player.dimensions/2, %Player.dimensions)
    for idx in level_structure.size():
        var tile: int = level_structure[idx]
        if tile == 8 and Globals.progress_flags.left_button_pressed and Globals.progress_flags.right_button_pressed:
            # If both buttons were pressed, spawn the blocks indexed as 8 as normal bricks. Otherwise, skip them.
            tile = 2
        if tile in intSceneMap:
            var scene: PackedScene = intSceneMap[tile] as PackedScene
            var pos: Vector2 = index_to_vector(idx)
            # If the player overlaps with one of these blocks, skip spawning it.
            if not player_bounds.has_point(pos):
                var instance: Node2D = scene.instantiate() as Node2D
                instance.position = pos
                $Floor.add_child(instance)
        elif tile != 0 and tile != 8:
            print('Missing tile index ', tile)
    


func index_to_vector(idx: int) -> Vector2:
    # Calculate X based on the index, which loops around. Subtract half of the level width as 0, 0 is the center of the level.
    # Add half a tile because of the center-anchored positioning.
    var x: float = idx % level_width * tile_size - (level_width/2*tile_size) + tile_size/2;
    # Same as X, but we divide and discard the floating point part to calculate the Y position.
    var y: float = idx / level_width * tile_size - (level_height/2*tile_size) + tile_size/2
    return Vector2(x, y)

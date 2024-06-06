extends Node2D
class_name LegacyLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var brick_scene: PackedScene = preload("res://scenes/objects/brick.tscn")
var movable_brick_scene: PackedScene = preload("res://scenes/objects/movable_brick.tscn")
var locked_brick_scene: PackedScene = preload("res://scenes/objects/locked_brick.tscn")
var level_width: int = Globals.LEVEL_WIDTH;
var level_height: int = Globals.LEVEL_HEIGHT;
var tile_size: int = Globals.TILE_SIZE;
var projectile: Area2D
var projectile_direction: Vector2 = Vector2.ZERO
var level_structure: Array[int] = [
	2, 2, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
	2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	2, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	2, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2,
	2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
	]

var intSceneMap: Dictionary = {
	1: movable_brick_scene,
	2: brick_scene,
	5: locked_brick_scene
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for idx in level_structure.size():
		var tile: int = level_structure[idx]
		if tile in intSceneMap:
			var scene: PackedScene = intSceneMap[tile] as PackedScene
			var instance: Node2D = scene.instantiate() as Node2D
			instance.position = index_to_vector(idx)
			add_child(instance)
		elif tile != 0:
			print('Missing tile index ', tile)
	%Player.position = Globals.player_spawn_position
	


func index_to_vector(idx: int) -> Vector2:
	# Calculate X based on the index, which loops around. Subtract half of the level width as 0, 0 is the center of the level.
	# Add half a tile because of the center-anchored positioning.
	var x: float = idx % level_width * tile_size - (level_width/2*tile_size) + tile_size/2;
	# Same as X, but we divide and discard the floating point part to calculate the Y position.
	var y: float = idx / level_width * tile_size - (level_height/2*tile_size) + tile_size/2
	return Vector2(x, y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if %Player.position.x > Globals.LEVEL_WIDTH_PX / 2:
		Globals.world_x += 1
		Globals.player_spawn_position = Vector2((-Globals.LEVEL_WIDTH_PX/2+1), %Player.position.y)
		Globals.player_spawn_velocity = %Player.velocity
		Globals.load_next_level()
	elif %Player.position.x < (-Globals.LEVEL_WIDTH_PX / 2):
		Globals.world_x -= 1
		Globals.player_spawn_position = Vector2((Globals.LEVEL_WIDTH_PX/2-1), %Player.position.y)
		Globals.player_spawn_velocity = %Player.velocity
		Globals.load_next_level()
	elif %Player.position.y < (-Globals.LEVEL_HEIGHT_PX / 2):
		Globals.world_y += 1
		Globals.player_spawn_position = Vector2(%Player.position.x, (Globals.LEVEL_HEIGHT_PX/2-1))
		Globals.player_spawn_velocity = %Player.velocity + Vector2(0, -400)
		%Player.move_and_slide()
		Globals.load_next_level()
	elif %Player.position.y > (Globals.LEVEL_HEIGHT_PX / 2):
		Globals.world_y -= 1
		Globals.player_spawn_position = Vector2(%Player.position.x, (-Globals.LEVEL_HEIGHT_PX/2+1))
		Globals.player_spawn_velocity = %Player.velocity
		Globals.load_next_level()
	pass

func _on_player_shoot_tk_projectile(angle: Vector2) -> void:
	var projectile: Area2D = telekinesis_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	add_child(projectile)
	pass # Replace with function body.

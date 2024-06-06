extends Node2D

const LEVEL_WIDTH: int = 36
const LEVEL_HEIGHT: int = 20
const TILE_SIZE: int = 32
const LEVEL_WIDTH_PX: int = LEVEL_WIDTH * TILE_SIZE
const LEVEL_HEIGHT_PX: int = LEVEL_HEIGHT * TILE_SIZE

var world_x: int = 2
var world_y: int = 0
var scene_template_string: String = "res://scenes/levels/level_{x}_{y}.tscn"
var player_spawn_position: Vector2 = Vector2(-304, -144)
var player_spawn_velocity: Vector2 = Vector2.ZERO

func load_next_level() -> void:
	var path: String = scene_template_string.format({"x": world_x, "y": world_y})
	get_tree().change_scene_to_file(path)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

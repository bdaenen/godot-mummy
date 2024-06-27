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

var player_skills: Dictionary = {
	"can_shoot": true,
	"can_link": true,
	"can_sprint": false
}

func load_next_level() -> void:
	var path: String = scene_template_string.format({"x": world_x, "y": world_y})
	get_tree().change_scene_to_file(path)

func get_input_action_keynames(action_name: String) -> Array:
	return InputMap.action_get_events(action_name).map(func (ev: InputEvent) -> String:
		return ev.as_text().split(' (')[0]
	) as Array

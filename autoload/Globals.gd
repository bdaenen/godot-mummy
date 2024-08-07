extends Node2D

const LEVEL_WIDTH: int = 36
const LEVEL_HEIGHT: int = 20
const TILE_SIZE: int = 32
const LEVEL_WIDTH_PX: int = LEVEL_WIDTH * TILE_SIZE
const LEVEL_HEIGHT_PX: int = LEVEL_HEIGHT * TILE_SIZE

var viewport_bounds: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width")/2, ProjectSettings.get_setting("display/window/size/viewport_height")/2)
var world_coord: Vector2i = Vector2i(2, 0)
var scene_template_string: String = "res://scenes/levels/level_{x}_{y}.tscn"
var player_spawn_position: Vector2 = Vector2(-304, -144)
#var player_spawn_position: Vector2 = Vector2(100, 80)
var player_spawn_velocity: Vector2 = Vector2.ZERO
var player_spawn_scale: Vector2 = Vector2(1, 1)
var visited_levels: Array[Vector2i] = [world_coord]
var warped_transition: bool = false
var progress_flags: Dictionary = {
    "obtained_upper_floor_key": false,
    "unlocked_upper_floor": false,
    "left_button_pressed": false,
    "right_button_pressed": false
}

var player_skills: Dictionary = {
    "can_shoot": false,
    "can_link": false,
    "can_sprint": false
}

#var player_skills: Dictionary = {
    #"can_shoot": true,
    #"can_link": true,
    #"can_sprint": false
#}


func has_visited_level(coordinate: Vector2i) -> bool:
    return visited_levels.has(coordinate)

func world_coordinate_exists(x: int, y: int) -> bool:
    var path: String = scene_template_string.format({"x": x, "y": y})
    return ResourceLoader.exists(path)

func load_next_level() -> void:
    var path: String = scene_template_string.format({"x": world_coord.x, "y": world_coord.y})
    if (!visited_levels.has(world_coord)):
        visited_levels.append(world_coord)
    get_tree().change_scene_to_file(path)

func get_input_action_keynames(action_name: String) -> Array:
    return InputMap.action_get_events(action_name).map(func (ev: InputEvent) -> String:
        return ev.as_text().split(' (')[0]
    ) as Array

func dump_state() -> Dictionary:
    return {
        "world_coord": world_coord,
        "player_spawn_position": player_spawn_position,
        "player_spawn_velocity": player_spawn_velocity,
        "player_spawn_scale": player_spawn_scale,
        "visited_levels": visited_levels,
        "warped_transition": warped_transition,
        "progress_flags": progress_flags,
        "player_skills": player_skills
    }

func load_state(state: Dictionary) -> void:
    world_coord = state.world_coord
    player_spawn_position = state.player_spawn_position
    player_spawn_velocity = state.player_spawn_velocity
    player_spawn_scale = state.player_spawn_scale
    visited_levels = state.visited_levels
    warped_transition = state.warped_transition
    progress_flags = state.progress_flags
    player_skills = state.player_skills

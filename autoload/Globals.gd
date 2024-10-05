extends Node2D

const LEVEL_WIDTH: int = 36
const LEVEL_HEIGHT: int = 20
const TILE_SIZE: int = 32
const LEVEL_WIDTH_PX: int = LEVEL_WIDTH * TILE_SIZE
const LEVEL_HEIGHT_PX: int = LEVEL_HEIGHT * TILE_SIZE
const KEYBOARD = 0
const JOYPAD = 1

var viewport_bounds: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width")/2, ProjectSettings.get_setting("display/window/size/viewport_height")/2)
var world_coord: Vector2i = Vector2i(2, 0)
var scene_template_string: String = "res://scenes/levels/level_{x}_{y}.tscn"
var player_spawn_position: Vector2 = Vector2(-304, -144)
var player_crosshair_spawn_position: Vector2 = Vector2(100, 0)
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

var current_input_mode: int = KEYBOARD

#var player_skills: Dictionary = {
    #"can_shoot": true,
    #"can_link": true,
    #"can_sprint": false
#}

func _ready() -> void:
    load_input_config('user://input.cfg', KEYBOARD)
    load_input_config('user://input_controller.cfg', JOYPAD)

## LEVEL SETUP
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

## INPUT HANDLING
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton or event is InputEventKey:
        current_input_mode = KEYBOARD
    elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
        current_input_mode = JOYPAD

func load_input_config(path: String, input_mode: int) -> void:
    var input_config: ConfigFile = ConfigFile.new()
    var err: Error = input_config.load(path)
    if (err != OK):
        return
    var actions: Array[StringName] = InputMap.get_actions().filter(func remove_ui_keys(action: StringName) -> bool:
        return not action.begins_with('ui_')
    )
    for section in input_config.get_sections():
        if section == "input":
            for action in actions:
                var saved_input: Variant = input_config.get_value('input', action, false)
                if (saved_input):
                    var existing_event: InputEvent = get_input_action_event(action, input_mode)
                    if (existing_event):
                        InputMap.action_erase_event(action, existing_event)
                    InputMap.action_add_event(action, saved_input)
    
func get_input_action_keyname(action_name: String, input_mode: int = -1) -> String:
    input_mode = input_mode if input_mode != -1 else current_input_mode
    if (input_mode == JOYPAD):
        return get_input_action_joypad_keyname(action_name)
    return get_input_action_keyboard_keyname(action_name)
    
func get_input_action_keyboard_keyname(action_name: String) -> String:
    var e: InputEvent = get_input_action_keyboard_event(action_name)
    if (e):
        return get_input_event_keyname(e)
    return '<unbound>'

func get_input_action_joypad_keyname(action_name: String) -> String:
    var e: InputEvent = get_input_action_joypad_event(action_name)
    if (e):
        return get_input_event_keyname(e)
    return '<unbound>'

func get_input_event_keyname(input_event: InputEvent) -> String:
    return input_event.as_text().split(' (')[0]

func get_input_action_event(action_name: String, input_mode: int = -1) -> InputEvent:
    input_mode = input_mode if input_mode != -1 else current_input_mode
    if (input_mode == JOYPAD):
        return get_input_action_joypad_event(action_name)
    return get_input_action_keyboard_event(action_name)

func get_input_action_keyboard_event(action_name: String) -> InputEvent:
    var actions: Array = InputMap.action_get_events(action_name)
    var filteredActions: Array = actions.filter(func (ev: InputEvent) -> bool:
        return ev is InputEventMouseButton or ev is InputEventKey
    )
    
    if (filteredActions.size() > 0):
        return filteredActions[0]
    return null
    
func get_input_action_joypad_event(action_name: String) -> InputEvent:
    var actions: Array = InputMap.action_get_events(action_name)
    var filteredActions: Array = actions.filter(func (ev: InputEvent) -> bool:
        return ev is InputEventJoypadButton or ev is InputEventJoypadMotion
    )
    
    if (filteredActions.size() > 0):
        return filteredActions[0]
    return null

func is_input_action_bound_to_gamepad(action_name: String) -> bool:
    return InputMap.action_get_events(action_name).any(func (ev: InputEvent) -> bool:
        print(ev)
        return ev is InputEventJoypadButton or ev is InputEventJoypadMotion
    )
    
const __2root2 := 2.0 * sqrt(2.0)

# Map a circle grid to a square grid
# input: vector from a circular domain with radius of 1
# output: vector in a square domain from (-1,-1) to (1,1)
func map_circle_to_square( xy :Vector2 ) -> Vector2:
    var x2 := xy[0]*xy[0]
    var y2 := xy[1]*xy[1]
    return Vector2(
        0.5 * (sqrt(2.0 + x2 - y2 + xy[0] * __2root2) - sqrt(2.0 + x2 - y2 - xy[0] * __2root2)),
        0.5 * (sqrt(2.0 - x2 + y2 + xy[1] * __2root2) - sqrt(2.0 - x2 + y2 - xy[1] * __2root2))
    )

# Map a square grid to a circular grid
# input: vector from a square domain from (-1,-1) to (1,1)
# output: vector in a circle domain with radius of 1
func map_square_to_circle( xy :Vector2 ) -> Vector2:
    return Vector2(
        xy.x * sqrt(1.0 - xy.y*xy.y/2.0),
        xy.y * sqrt(1.0 - xy.x*xy.x/2.0)
    )


## SAVE/LOAD
func dump_state() -> Dictionary:
    return {
        "world_coord": world_coord,
        "player_spawn_position": player_spawn_position,
        "player_crosshair_spawn_position": player_crosshair_spawn_position,
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
    player_crosshair_spawn_position = state.player_crosshair_spawn_position
    player_spawn_velocity = state.player_spawn_velocity
    player_spawn_scale = state.player_spawn_scale
    visited_levels = state.visited_levels
    warped_transition = state.warped_transition
    progress_flags = state.progress_flags
    player_skills = state.player_skills

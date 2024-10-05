extends KeybindSettingsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    config_path = 'user://input_controller.cfg'
    scene_input_mode = Globals.JOYPAD
    super()


func get_actions() -> Array[StringName]:
    return InputMap.get_actions().filter(func remove_ui_keys(action: StringName) -> bool:
        return not action.begins_with('ui_')
    )

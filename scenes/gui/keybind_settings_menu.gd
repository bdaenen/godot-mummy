extends Control

var keybind_button: PackedScene = preload('res://scenes/gui/keybind_button.tscn')

@onready var config: ConfigFile = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var err: Error = config.load('user://input.cfg')
    if (err == ERR_FILE_CANT_OPEN):
        config.save('user://input.cfg')
    
    var actions: Array[StringName] = InputMap.get_actions().filter(func remove_ui_keys(action: StringName) -> bool:
        return not action.begins_with('ui_')
    )

    for action in actions:
        var btn: Control = keybind_button.instantiate()
        btn.action_string_name = action
        btn.connect('waiting_for_input', disable_buttons)
        btn.connect('waiting_complete', enable_buttons)
        btn.connect('keybind_changed', update_config_file)
        %KeybindContainer.add_child(btn)
    
func disable_buttons() -> void:
    for btn in %KeybindContainer.get_children():
        btn.disabled = true

func enable_buttons() -> void:
    print('reenabling buttons')
    for btn in %KeybindContainer.get_children():
        btn.disabled = false

func update_config_file(action: StringName, event: InputEvent) -> void:
    config.set_value('input', action, event)
    config.save('user://input.cfg')
    print(config.get_sections())

func _on_button_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/main_settings_menu.tscn')

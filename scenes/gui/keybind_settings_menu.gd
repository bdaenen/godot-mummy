class_name KeybindSettingsMenu
extends Control
var config_path: String = 'user://input.cfg'
var scene_input_mode: int = Globals.KEYBOARD
var keybind_button: PackedScene = preload('res://scenes/gui/keybind_button.tscn')

@onready var config: ConfigFile = ConfigFile.new()

func load_config_file() -> void:
    var err: Error = config.load(config_path)
    if (err == ERR_FILE_CANT_OPEN):
        config.save(config_path)
    
func get_actions() -> Array[StringName]:
    return InputMap.get_actions().filter(func remove_ui_keys(action: StringName) -> bool:
        return not action.begins_with('ui_') and not action.begins_with('_controller_')
    )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    print('loading', config_path)
    load_config_file()
    
    var actions: Array[StringName] = get_actions()

    for action in actions:
        var btn: Control = keybind_button.instantiate()
        btn.action_string_name = action
        btn.input_mode = scene_input_mode
        btn.connect('waiting_for_input', disable_buttons)
        btn.connect('waiting_complete', enable_buttons)
        btn.connect('keybind_changed', update_config_file)
        %KeybindContainer.add_child(btn)
    
func disable_buttons() -> void:
    for btn in %KeybindContainer.get_children():
        btn.disabled = true

func enable_buttons() -> void:
    for btn in %KeybindContainer.get_children():
        btn.disabled = false

func update_config_file(action: StringName, event: InputEvent) -> void:
    config.set_value('input', action, event)
    config.save(config_path)
    print(config.get_sections())

func _on_button_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/main_settings_menu.tscn')

extends BaseSettingsMenu

var keybind_scene: PackedScene = preload('res://scenes/keybind_settings_menu.tscn')
var controller_keybind_scene: PackedScene = preload('res://scenes/gui/joypad_binding_settings_menu.tscn')

func _on_root_settings_menu_keybind_button_pressed() -> void:
    get_tree().change_scene_to_packed(keybind_scene)

func _on_root_settings_menu_controller_binding_button_pressed() -> void:
    get_tree().change_scene_to_packed(controller_keybind_scene)

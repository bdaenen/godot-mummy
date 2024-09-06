extends Control
signal keybind_button_pressed()

func _on_keybind_buttons_pressed() -> void:
    keybind_button_pressed.emit()


func _on_button_pressed() -> void:
    get_tree().change_scene_to_file('res://scenes/main_menu.tscn')

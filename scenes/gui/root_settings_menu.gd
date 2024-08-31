extends Control
signal keybind_button_pressed()

func _on_keybind_buttons_pressed() -> void:
    keybind_button_pressed.emit()

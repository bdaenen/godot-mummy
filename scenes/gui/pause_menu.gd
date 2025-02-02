extends MarginContainer
signal resume_click()
signal reset_click()
signal save_quit_click()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var input_actions: String = Globals.get_input_action_keyname('Reset Room')    
    var reset_button: Button = $Panel/MarginContainer/VBoxContainer/ResetRoomButton
    reset_button.text = reset_button.text + (" <%s>" % input_actions)

func _on_resume_button_pressed() -> void:
    resume_click.emit()

func _on_reset_room_button_pressed() -> void:
    reset_click.emit()

func _on_save_and_quit_button_pressed() -> void:
    save_quit_click.emit()

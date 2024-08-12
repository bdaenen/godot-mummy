extends VBoxContainer
signal new_game_pressed()
signal continue_pressed()
signal settings_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if not SaverLoader.saved_game_exists():
        $VBoxContainer/Continue.hide()


func _on_continue_pressed() -> void:
    continue_pressed.emit()

func _on_new_game_pressed() -> void:
    new_game_pressed.emit()

func _on_settings_pressed() -> void:
    settings_pressed.emit()

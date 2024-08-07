extends Node2D


# Hide the continue button if there is no savegame
func _ready() -> void:
    if not SaverLoader.saved_game_exists():
        $VBoxContainer/Continue.hide()


func _on_new_game_pressed() -> void:
    Globals.load_next_level()


func _on_continue_pressed() -> void:
    if SaverLoader.saved_game_exists():
        SaverLoader.load_saved_state()
        Globals.load_next_level()

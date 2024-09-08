extends Node2D

var settings_scene: PackedScene = preload('res://scenes/main_settings_menu.tscn')

func _on_new_game_pressed() -> void:        
    Globals.load_next_level()
   

func _on_main_menu_continue_pressed() -> void:
    if SaverLoader.saved_game_exists():
        SaverLoader.load_saved_state()
        Globals.load_next_level()


func _on_main_menu_new_game_pressed() -> void:
    Globals.load_next_level()


func _on_main_menu_settings_pressed() -> void:
    get_tree().change_scene_to_packed(settings_scene)
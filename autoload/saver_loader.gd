extends Node
var file_path: String = "user://savegame.save"

func save_current_state() -> bool:
    var save_file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
    if save_file == null:
        print("Failed to save savegame file.")
        return false

    var state_data: Dictionary = Globals.dump_state()
    save_file.store_var(state_data, true)
    save_file.flush()
    return true

func load_saved_state() -> bool:
    var save_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
    if save_file == null:
        print("Failed to load savegame file.")
        return false
    var content: Dictionary = save_file.get_var(true)
    var typecasted_visited_levels: Array[Vector2i] = []
    typecasted_visited_levels.assign(content.visited_levels)
    content.visited_levels = typecasted_visited_levels
    Globals.load_state(content)
    return true
    
func saved_game_exists() -> bool:
    return FileAccess.file_exists(file_path)

func remove_save() -> bool:
    return DirAccess.remove_absolute(file_path) == Error.OK

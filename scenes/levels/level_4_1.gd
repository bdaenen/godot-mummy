extends GodotLevel

func _ready() -> void:
    super()
    $Platforms/ChestKey.was_looted = Globals.progress_flags.obtained_upper_floor_key

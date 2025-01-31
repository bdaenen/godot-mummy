extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if Globals.progress_flags.unlocked_upper_floor == true:
        queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    if Globals.progress_flags.obtained_upper_floor_key:
        Globals.progress_flags.unlocked_upper_floor = true
        queue_free()

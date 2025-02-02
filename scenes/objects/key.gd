extends Area2D

func _init() -> void:
    if (Globals.progress_flags.obtained_upper_floor_key == true):
        queue_free()

func _on_body_entered(_body: Node2D) -> void:
    Globals.progress_flags.obtained_upper_floor_key = true
    $AudioStreamPlayer.play()
    visible = false
    await $AudioStreamPlayer.finished
    queue_free()

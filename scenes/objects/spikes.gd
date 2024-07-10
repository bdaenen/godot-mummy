extends Area2D
signal player_killed()

func _on_body_entered(_body: Node2D) -> void:
    player_killed.emit()

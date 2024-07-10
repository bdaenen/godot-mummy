extends Area2D
var has_collided: bool = false

func _on_body_entered(body: Node2D) -> void:
    if !has_collided && !body.is_queued_for_deletion():
        has_collided = true
        body.queue_free()
        queue_free()

extends Area2D
var has_collided: bool = false
signal block_deleted(block: AnimatableBody2D)

func _on_body_entered(body: AnimatableBody2D) -> void:
    if !has_collided && !body.is_queued_for_deletion():
        has_collided = true
        block_deleted.emit(body)
        
        queue_free()

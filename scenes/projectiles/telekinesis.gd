extends Area2D
var angle: Vector2 = Vector2.ZERO
const SPEED:int = 400
var has_collided: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func _physics_process(delta: float) -> void:
    global_position += angle * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    if ("is_movable" in body and !has_collided):
        has_collided = true
        var tween: Tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(body, "position", position + angle * 100, 1)
        tween.play()
    queue_free()


func _on_despawn_timer_timeout() -> void:
    queue_free()

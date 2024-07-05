extends Area2D
signal on_hit(body: Node2D)
var angle: Vector2 = Vector2.ZERO
var has_collided: bool = false
const SPEED:int = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


func _physics_process(delta: float) -> void:
    global_position += angle * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
    if (!has_collided):
        on_hit.emit(body)
        has_collided = true;
    queue_free()

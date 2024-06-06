extends Area2D
var angle: Vector2 = Vector2.ZERO
const SPEED:int = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position += angle * SPEED * delta



func _on_body_entered(body: Node2D) -> void:
	print('hit that', body)

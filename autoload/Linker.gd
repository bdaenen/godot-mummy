extends Node2D

var linked_bodies: Array[RigidBody2D] = []

func add_body(body: RigidBody2D) -> void:
	if !linked_bodies.has(body):
		linked_bodies.append(body)
		body.is_linked = true
	print('Linker: linked ', linked_bodies.size() , ' bodies.')

func clear_bodies() -> void:
	linked_bodies.clear()

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Loop over the linked_nodes here and sync their velocities.
	if linked_bodies.size() == 0:
		return

	var shared_velocity_body: RigidBody2D
	for body in linked_bodies:
		if body.linear_velocity.abs().x + body.linear_velocity.abs().y < 1:
			body.linear_velocity = Vector2.ZERO
		elif "is_movable" in body and body.is_movable:
			shared_velocity_body = body
			break
	
	if shared_velocity_body:
		print(shared_velocity_body, shared_velocity_body.linear_velocity, shared_velocity_body.linear_velocity.is_zero_approx())
		for body in linked_bodies.filter(func(b): return b != shared_velocity_body):
			body.linear_velocity = shared_velocity_body.linear_velocity

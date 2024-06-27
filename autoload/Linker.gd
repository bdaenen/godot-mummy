extends Node2D

var linked_bodies: Array[RigidBody2D] = []
var link_line: Line2D
var shared_velocity_body: RigidBody2D

signal body_linked(body: RigidBody2D)
signal cleared_links()

func add_body(body: RigidBody2D) -> void:
	if !linked_bodies.has(body):
		linked_bodies.append(body)
		if link_line:
			link_line.add_point(body.global_position)
		body_linked.emit(body)
	print('Linker: linked ', linked_bodies.size() , ' bodies.')

func clear_bodies() -> void:
	var unlinked_bodies: Array[RigidBody2D] = linked_bodies.duplicate()
	linked_bodies.clear()
	cleared_links.emit(unlinked_bodies)

func set_line2d(line: Line2D):
	link_line = line

func get_moving_block_velocity() -> Vector2:
	if shared_velocity_body:
		return shared_velocity_body.linear_velocity
	return Vector2.ZERO

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

	for body in linked_bodies:
		if body.linear_velocity.abs().x + body.linear_velocity.abs().y < 1:
			body.linear_velocity = Vector2.ZERO
			shared_velocity_body = null
		elif "is_movable" in body and body.is_movable:
			shared_velocity_body = body
			break
	
	if shared_velocity_body:
		print(shared_velocity_body, shared_velocity_body.linear_velocity, shared_velocity_body.linear_velocity.is_zero_approx())
		for i in linked_bodies.size():
			var body: RigidBody2D = linked_bodies[i]
			if body != shared_velocity_body:
				body.linear_velocity = shared_velocity_body.linear_velocity
			link_line.points[i] = body.global_position
			
		# for body in linked_bodies.filter(func(b): return b != shared_velocity_body):
			

extends Node2D

var linked_bodies: Array[AnimatableBody2D] = []
var linked_bodies_previous_positions: Array[Vector2] = []
var link_line: Line2D
var shared_velocity_body: AnimatableBody2D
var shared_velocity_body_idx: int

signal body_linked(body: AnimatableBody2D)
signal cleared_links()

func add_body(body: AnimatableBody2D) -> void:
	if !linked_bodies.has(body):
		linked_bodies.append(body)
		linked_bodies_previous_positions.append(body.global_position)
		if link_line:
			link_line.add_point(body.global_position)
		body_linked.emit(body)
	print('Linker: linked ', linked_bodies.size() , ' bodies.')

func clear_bodies() -> void:
	var unlinked_bodies: Array[AnimatableBody2D] = linked_bodies.duplicate()
	linked_bodies.clear()
	linked_bodies_previous_positions.clear()
	shared_velocity_body_idx = -1
	shared_velocity_body = null
	cleared_links.emit(unlinked_bodies)

func set_line2d(line: Line2D):
	link_line = line

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Loop over the linked_nodes here and sync their movement.
	if linked_bodies.size() == 0:
		return

	var move_diff: Vector2 = Vector2.ZERO
	
	# If we found a moving linked_body, update all linked bodies' and line point positions with the diff
	if shared_velocity_body:
		var prev_pos: Vector2 = linked_bodies_previous_positions[shared_velocity_body_idx]
		# Movement since last frame
		move_diff = prev_pos - shared_velocity_body.global_position
		
		if move_diff.is_zero_approx():
			# Stop the sync
			shared_velocity_body = null
		else:
			# Sync movement between shared_velocity_body and linked_bodies
			for i in linked_bodies.size():
				var body: AnimatableBody2D = linked_bodies[i]
				if body != shared_velocity_body:
					body.global_position = body.global_position - move_diff
				link_line.points[i] = body.global_position
	else:
		# Find the first movable body that actually moved
		for i in linked_bodies.size():
			var body: AnimatableBody2D = linked_bodies[i]
			var prev_pos: Vector2 = linked_bodies_previous_positions[i]
			if "is_movable" in body and body.is_movable and prev_pos != body.global_position:
				shared_velocity_body = body
				shared_velocity_body_idx = i
				break

	# Keep track of the previous position
	for i in linked_bodies.size():
		var body: AnimatableBody2D = linked_bodies[i]
		linked_bodies_previous_positions[i] = body.global_position

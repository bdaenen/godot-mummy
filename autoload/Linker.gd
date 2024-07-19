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
        body.is_linked = true
        linked_bodies.append(body)
        linked_bodies_previous_positions.append(body.global_position)
        if link_line:
            link_line.add_point(body.global_position)
        body_linked.emit(body)
    print('Linking ', body, '...')
    print('Linker: linked ', linked_bodies.size() , ' bodies.')

func remove_body(body: AnimatableBody2D) -> void:
    var index: int = linked_bodies.find(body, 0)
    if index > -1:
        body.is_linked = false
        linked_bodies.remove_at(index)
        linked_bodies_previous_positions.remove_at(index)
        if link_line:
            link_line.remove_point(index)
        if shared_velocity_body == body:
            shared_velocity_body_idx = -1
            shared_velocity_body = null
        elif shared_velocity_body_idx > index:
            shared_velocity_body_idx -= 1
    print('Unlinking ', body, '...')
    print('Linker: linked ', linked_bodies.size() , ' bodies.')

func clear_bodies() -> void:
    for i in linked_bodies.size():
        var body: AnimatableBody2D = linked_bodies[i]
        body.is_linked = false
        if link_line:
            link_line.remove_point(0)
    linked_bodies.clear()
    linked_bodies_previous_positions.clear()
    shared_velocity_body_idx = -1
    shared_velocity_body = null
    cleared_links.emit()

func set_line2d(line: Line2D) -> void:
    link_line = line

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
    # Loop over the linked_nodes here and sync their movement.
    if linked_bodies.size() == 0:
        return

    var move_diff: Vector2 = Vector2.ZERO
    
    # If we found a moving linked_body, update all linked bodies' and line point positions with the diff
    if is_instance_valid(shared_velocity_body):
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

    # Keep track of the previous position, and cull offscreen bodies
    var bodies_to_remove: Array[AnimatableBody2D] = []
    var viewport_bounds: Vector2 = Globals.viewport_bounds
    for i in linked_bodies.size():
        var body: AnimatableBody2D = linked_bodies[i]
        linked_bodies_previous_positions[i] = body.global_position
        var bpos: Vector2 = body.global_position
        if bpos.x > viewport_bounds.x || bpos.x < -viewport_bounds.x || bpos.y > viewport_bounds.y || bpos.y < -viewport_bounds.y:
            bodies_to_remove.append(body)
            
    while (bodies_to_remove.size()):
        var body_to_remove: AnimatableBody2D = bodies_to_remove[0]
        remove_body(body_to_remove)
        bodies_to_remove.remove_at(0)
        body_to_remove.queue_free()

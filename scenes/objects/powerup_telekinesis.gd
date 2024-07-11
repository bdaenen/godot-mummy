extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (Globals.player_skills.can_shoot):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# Technically this isn't necessary as we have a collision mask on the player group already, but it's a good Group example
	print(body,' entered')
	print(body.is_in_group('Player'))
	if (body.is_in_group('Player')):
		body.set_can_shoot(true)
		queue_free()

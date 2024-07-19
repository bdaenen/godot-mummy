extends Powerup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if (Globals.player_skills.can_link):
        queue_free()



func _on_picked_up(body: Node2D) -> void:
     # Technically this isn't necessary as we have a collision mask on the player group already, but it's a good Group example
    if (body.is_in_group('Player')):
        body.set_can_link(true)
        $AudioStreamPlayer.play()


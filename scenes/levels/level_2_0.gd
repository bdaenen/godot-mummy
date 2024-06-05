extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player.position = Globals.player_spawn_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if %Player.position.x > 18 * 32:
		Globals.world_x += 1
		Globals.player_spawn_position = Vector2((0 - Globals.LEVEL_WIDTH_PX/2), %Player.position.y)
		Globals.load_next_level()
	pass

extends GodotLevel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if %Player.position.x > Globals.LEVEL_WIDTH_PX / 2:
        Globals.world_x += 1
        Globals.player_spawn_position = Vector2((-Globals.LEVEL_WIDTH_PX/2+1), %Player.position.y)
        Globals.player_spawn_velocity = %Player.velocity
        Globals.load_next_level()
    elif %Player.position.x < (-Globals.LEVEL_WIDTH_PX / 2):
        Globals.world_x -= 1
        Globals.player_spawn_position = Vector2((Globals.LEVEL_WIDTH_PX/2-1), %Player.position.y)
        Globals.player_spawn_velocity = %Player.velocity
        Globals.load_next_level()
    elif %Player.position.y < (-Globals.LEVEL_HEIGHT_PX / 2):
        Globals.world_y += 1
        Globals.player_spawn_position = Vector2(%Player.position.x, (Globals.LEVEL_HEIGHT_PX/2-1))
        Globals.player_spawn_velocity = %Player.velocity + Vector2(0, -400)
        %Player.move_and_slide()
        Globals.load_next_level()
    elif %Player.position.y > (Globals.LEVEL_HEIGHT_PX / 2):
        Globals.world_y -= 1
        Globals.player_spawn_position = Vector2(%Player.position.x, (-Globals.LEVEL_HEIGHT_PX/2+1))
        Globals.player_spawn_velocity = %Player.velocity
        Globals.load_next_level()
    pass

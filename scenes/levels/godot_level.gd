extends Node2D
class_name GodotLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var link_projectile: PackedScene = preload("res://scenes/projectiles/link.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player.position = Globals.player_spawn_position

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

func _on_player_shoot_tk_projectile(angle: Vector2) -> void:

	var projectile: Area2D = telekinesis_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	add_child(projectile)


func _on_player_shoot_link_projectile(angle: Vector2) -> void:
	var projectile: Area2D = link_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	add_child(projectile)

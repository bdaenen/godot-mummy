extends Node2D
class_name GodotLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var link_projectile: PackedScene = preload("res://scenes/projectiles/link.tscn")
var tutorial_dismiss_action: String = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player.position = Globals.player_spawn_position
	$Linker.clear_bodies()
	$Linker.set_line2d($LinkLine)

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
	
	if tutorial_dismiss_action.length() and Input.is_action_just_pressed(tutorial_dismiss_action):
		$CanvasLayer/TutorialOverlay.fadeOut()
		tutorial_dismiss_action = ''
		

func _on_player_shoot_tk_projectile(angle: Vector2) -> void:
	var projectile: Area2D = telekinesis_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	add_child(projectile)


func _on_player_shoot_link_projectile(angle: Vector2) -> void:
	var projectile: Area2D = link_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	projectile.connect("on_hit", self._on_link_hit)
	add_child(projectile)

func _on_link_hit(body: RigidBody2D) -> void:
	# This enables the shader for the green borders
	body.is_linked = true
	$Linker.add_body(body)

func _on_linker_cleared_links(bodies: Array[RigidBody2D]) -> void:
	for body in bodies:
		body.is_linked = false


func _on_player_gain_telekinesis() -> void:
	var input_actions: Array = Globals.get_input_action_keynames('Shoot')
	$CanvasLayer/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto use telekinesis" % ' OR '.join(input_actions))
	$CanvasLayer/TutorialOverlay.fadeIn(1)
	tutorial_dismiss_action = 'Shoot'

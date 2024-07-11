extends Node2D
class_name GodotLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var link_projectile: PackedScene = preload("res://scenes/projectiles/link.tscn")
var tutorial_dismiss_action: String = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var regex: RegEx = RegEx.new()
	regex.compile("^Level_(\\d)_(\\d)$")
	var result: RegExMatch = regex.search(name)
	if result and result.get_group_count() == 2:
		Globals.world_coord = Vector2i(int(result.get_string(1)), int(result.get_string(2)))
	# print(result.get_string(2))
	
	print(name)
	if !$"/root/BgMusicPlayer".is_playing():
		$"/root/BgMusicPlayer".play()

	$Linker.clear_bodies()
	$Linker.set_line2d($LinkLine)
	var player_bounds: Rect2 = Rect2(Globals.player_spawn_position - %Player.dimensions/2, %Player.dimensions)
	for child: AnimatableBody2D in $Walls.get_children():
		if player_bounds.has_point(child.global_position):
			child.queue_free()
			await child.tree_exited
	for child in $Floor.get_children():
		if player_bounds.has_point(child.global_position):
			child.queue_free()
			await child.tree_exited
	for child in $Platforms.get_children():
		if player_bounds.has_point(child.global_position):
			child.queue_free()
			await child.tree_exited
	
	%Player.position = Globals.player_spawn_position
	%Player/Sprite2D.scale = Globals.player_spawn_scale
	%Player.velocity = Globals.player_spawn_velocity

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Reset Room"):
		Globals.load_next_level()

func _physics_process(_delta: float) -> void:
	if %Player.position.x > Globals.LEVEL_WIDTH_PX / 2:
		if Globals.world_coordinate_exists(Globals.world_coord.x+1, Globals.world_coord.y):
			Globals.world_coord.x += 1
			Globals.player_spawn_position = Vector2((-Globals.LEVEL_WIDTH_PX/2+1), %Player.position.y)
			Globals.player_spawn_velocity = %Player.velocity
			Globals.player_spawn_scale = %Player/Sprite2D.scale
			Globals.load_next_level()
		else:
			%Player.velocity.x = -1000
			%Player.move_and_slide()
	elif %Player.position.x < (-Globals.LEVEL_WIDTH_PX / 2):
		if Globals.world_coordinate_exists(Globals.world_coord.x-1, Globals.world_coord.y):
			Globals.world_coord.x -= 1
			Globals.player_spawn_position = Vector2((Globals.LEVEL_WIDTH_PX/2-1), %Player.position.y)
			Globals.player_spawn_velocity = %Player.velocity
			Globals.player_spawn_scale = %Player/Sprite2D.scale
			Globals.load_next_level()
		else:
			%Player.velocity.x = 1000
			%Player.move_and_slide()
	elif %Player.position.y < (-Globals.LEVEL_HEIGHT_PX / 2):
		if Globals.world_coordinate_exists(Globals.world_coord.x, Globals.world_coord.y+1):
			Globals.world_coord.y += 1
			Globals.player_spawn_position = Vector2(%Player.position.x, (Globals.LEVEL_HEIGHT_PX/2-1))
			# When we move up, make sure we can make the jump into the room by adding some extra upward velocity.
			Globals.player_spawn_velocity = %Player.velocity + Vector2(0, -400)
			Globals.player_spawn_scale = %Player/Sprite2D.scale
			Globals.load_next_level()
		else:
			%Player.velocity.y = 500
			%Player.move_and_slide()
	elif %Player.position.y > (Globals.LEVEL_HEIGHT_PX / 2):
		if Globals.world_coordinate_exists(Globals.world_coord.x, Globals.world_coord.y-1):
			Globals.world_coord.y -= 1
			Globals.player_spawn_position = Vector2(%Player.position.x, (-Globals.LEVEL_HEIGHT_PX/2+1))
			Globals.player_spawn_velocity = %Player.velocity
			Globals.player_spawn_scale = %Player/Sprite2D.scale
			Globals.load_next_level()
		else:
			%Player.velocity.y = -500
			%Player.move_and_slide()
			%Player.play_sound_jump()
	
	if tutorial_dismiss_action.length() and Input.is_action_just_pressed(tutorial_dismiss_action):
		$CanvasLayer/TutorialOverlay.fadeOut()
		tutorial_dismiss_action = ''
		

func _on_player_shoot_tk_projectile(angle: Vector2) -> void:
	var projectile: Area2D = telekinesis_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	var size: int = $Projectiles.get_children().filter(
		func find_tk_projectile(child: Area2D) -> bool:
			return 'is_telekinesis' in child
	).size()
	if size == 0:
		$Projectiles.add_child(projectile)


func _on_player_shoot_link_projectile(angle: Vector2) -> void:
	if $Linker.linked_bodies.size() >= 2:
		return
	var projectile: Area2D = link_projectile.instantiate() as Area2D
	projectile.angle = angle
	projectile.position = %Player.global_position
	projectile.connect("on_hit", self._on_link_hit)    
	var size: int = $Projectiles.get_children().filter(
		func find_link_projectile(child: Area2D) -> bool:
			return 'is_link' in child
	).size()
	if size == 0:
		$Projectiles.add_child(projectile)

func _on_link_hit(body: AnimatableBody2D) -> void:
	# This enables the shader for the green borders
	$Linker.add_body(body)


func _on_player_gain_telekinesis() -> void:
	var input_actions: Array = Globals.get_input_action_keynames('Shoot')
	$CanvasLayer/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto use telekinesis" % ' OR '.join(input_actions))
	$CanvasLayer/TutorialOverlay.fadeIn(.5)
	tutorial_dismiss_action = 'Shoot'


func _on_player_gain_link() -> void:
	var input_actions: Array = Globals.get_input_action_keynames('Link')
	$CanvasLayer/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto use link and connect two blocks together" % ' OR '.join(input_actions))
	$CanvasLayer/TutorialOverlay.fadeIn(.5)
	tutorial_dismiss_action = 'Link'
	$Linker.connect('body_linked', checkIfTwoLinked)
	
func checkIfTwoLinked(_body: AnimatableBody2D) -> void:
	if $Linker.linked_bodies.size() == 2:
		var reset_input_actions: Array = Globals.get_input_action_keynames('Clear Link')
		$CanvasLayer/TutorialOverlay.set_content("Linked blocks move together. \n Press <%s>\nto reset" % ' OR '.join(reset_input_actions))
		$CanvasLayer/TutorialOverlay.fadeIn(.5)
		tutorial_dismiss_action = 'Clear Link'
		$Linker.disconnect('body_linked', checkIfTwoLinked)

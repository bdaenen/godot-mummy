extends Node2D
class_name GodotLevel

var telekinesis_projectile: PackedScene = preload("res://scenes/projectiles/telekinesis.tscn")
var link_projectile: PackedScene = preload("res://scenes/projectiles/link.tscn")
var tutorial_dismiss_action: String = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if !$"/root/BgMusicPlayer".is_playing():
        $"/root/BgMusicPlayer".play()

    %Player.position = Globals.player_spawn_position
    %Player/Sprite2D.scale = Globals.player_spawn_scale
    %Player.velocity = Globals.player_spawn_velocity
    $Linker.clear_bodies()
    $Linker.set_line2d($LinkLine)
    var player_bounds: Rect2 = Rect2(%Player.global_position - %Player.dimensions/2, %Player.dimensions)
    for child: AnimatableBody2D in $Walls.get_children():
        if player_bounds.has_point(child.global_position):
            child.free()
    for child in $Floor.get_children():
        if player_bounds.has_point(child.global_position):
            child.free()
    for child in $Platforms.get_children():
        if player_bounds.has_point(child.global_position):
            child.free()

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
            print(%Player.scale)
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
    add_child(projectile)


func _on_player_shoot_link_projectile(angle: Vector2) -> void:
    var projectile: Area2D = link_projectile.instantiate() as Area2D
    projectile.angle = angle
    projectile.position = %Player.global_position
    projectile.connect("on_hit", self._on_link_hit)
    add_child(projectile)

func _on_link_hit(body: AnimatableBody2D) -> void:
    # This enables the shader for the green borders
    $Linker.add_body(body)


func _on_player_gain_telekinesis() -> void:
    var input_actions: Array = Globals.get_input_action_keynames('Shoot')
    $CanvasLayer/TutorialOverlay.set_content("New ability unlocked! \n Press <%s>\nto use telekinesis" % ' OR '.join(input_actions))
    $CanvasLayer/TutorialOverlay.fadeIn(1)
    tutorial_dismiss_action = 'Shoot'

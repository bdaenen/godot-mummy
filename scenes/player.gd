extends CharacterBody2D

signal shoot_tk_projectile(angle: Vector2)
signal shoot_link_projectile(angle: Vector2)
signal gain_telekinesis()
signal gain_link()
signal gain_sprint()

@export var linker_ref: Node2D = null

const SPEED = 200.0
const SPRINT_SPEED = 400.0
const JUMP_VELOCITY = -600.0
var is_jump_ready: bool = true
var is_shoot_bound_to_gamepad: bool = Globals.is_input_action_bound_to_gamepad('Shoot')



var dimensions: Vector2 = Vector2.ZERO
var dead: bool = false
var input_disabled: bool = false
var skills: Dictionary = {
    "can_shoot": Globals.player_skills.can_shoot,
    "can_link": Globals.player_skills.can_link,
    "can_sprint": Globals.player_skills.can_sprint
}:
    get:
        return skills

var prev_is_on_floor: bool = true

func set_can_shoot(can_shoot: bool) -> void:
    if !skills.can_shoot and can_shoot:
        gain_telekinesis.emit()
    skills.can_shoot = can_shoot
    Globals.player_skills.can_shoot = can_shoot
    

func set_can_link(can_link: bool) -> void:
    if !skills.can_link and can_link:
        gain_link.emit()
    skills.can_link = can_link
    Globals.player_skills.can_link = can_link

func set_can_sprint(can_sprint: bool) -> void:
    if !skills.can_sprint and can_sprint:
        gain_sprint.emit()
    skills.can_sprint = can_sprint
    Globals.player_skills.can_sprint = can_sprint


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func play_warp_reverse_sound() -> void:
    $SfxWarp.play()

func play_sound_jump() -> void:
    if !dead:
        $SfxJump.play()

func _ready() -> void:
    dimensions = Vector2($Sprite2D.texture.get_width() * $Sprite2D.scale.x, $Sprite2D.texture.get_height() * $Sprite2D.scale.y)
    if (Globals.warped_transition):
        input_disabled = true
        Globals.warped_transition = false
        var tween: Tween = create_tween()
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(self, 'rotation_degrees', 0, 3).from(720)
        tween.tween_property(self, 'scale:x', 1, 3).from(0.2)
        tween.tween_property(self, 'scale:y', 1, 3).from(0.2)
        tween.play()
        play_warp_reverse_sound()
        tween.connect('finished', func finish() -> void:
            input_disabled = false
        )

func _physics_process(delta: float) -> void:
    if dead:
        return
    
    if input_disabled:
        $WalkAnimationTimer.set_paused(true)
        $SfxWalkTimer.stop()
        $SfxWalkTimer.start()
        $SfxWalkTimer.set_paused(true)
        return
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump.
    if Input.is_action_pressed("Jump") and is_on_floor() and is_jump_ready:
        is_jump_ready = false
        $JumpCooldown.start()
        velocity.y = JUMP_VELOCITY
        play_sound_jump()

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis("Left", "Right")
    var is_sprinting: bool = Input.is_action_pressed("Sprint") and skills.can_sprint
    $SfxWalkTimer.wait_time = 0.1 if is_sprinting else 0.2
    $WalkAnimationTimer.wait_time = 0.05 if is_sprinting else 0.1
    var speed: float = SPRINT_SPEED if is_sprinting else SPEED
    
    if direction:
        velocity.x = direction * speed
        if is_on_floor():
            $WalkAnimationTimer.set_paused(false)
        if $SfxWalkTimer.paused:
            $SfxWalkTimer.set_paused(false)
            if is_on_floor():
                pass
                #$SfxWalk.play()
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        $WalkAnimationTimer.set_paused(true)
        $SfxWalkTimer.stop()
        $SfxWalkTimer.start()
        $SfxWalkTimer.set_paused(true)
        $Sprite2D.position.y = 0
    
    move_and_slide()

    if not is_shoot_bound_to_gamepad:
        $Crosshair.global_position = round(get_global_mouse_position())
    else:
        var crosshair_horizontal_direction := Input.get_axis("Aim_Left", "Aim_Right")
        var crosshair_vertical_direction := Input.get_axis("Aim_Up", "Aim_Down")
        if abs(crosshair_horizontal_direction) > 0.5 or abs(crosshair_vertical_direction) > 0.5:
            $Crosshair.global_position = global_position + (Vector2(crosshair_horizontal_direction, crosshair_vertical_direction) * 100)

func _process(_delta: float) -> void:
    if dead or input_disabled:
        return
    if Input.is_action_pressed("Left"):
        $Sprite2D.scale.x = -1
    elif Input.is_action_pressed("Right"):
        $Sprite2D.scale.x = 1
    if is_on_floor() and not prev_is_on_floor:
        # reset the walk timer
        $SfxWalkTimer.start()
        $WalkAnimationTimer.start()
        $SfxWalk.play()
    elif not is_on_floor() and prev_is_on_floor:
        $SfxWalkTimer.set_paused(true)
        $WalkAnimationTimer.set_paused(true)

    if Input.is_action_just_pressed("Shoot") and skills.can_shoot:
        #shoot_tk_projectile.emit(global_position.direction_to(get_global_mouse_position()))
        shoot_tk_projectile.emit(global_position.direction_to($Crosshair.global_position))
    if Input.is_action_just_pressed("Link") and skills.can_link:
        shoot_link_projectile.emit(global_position.direction_to($Crosshair.global_position))
    if Input.is_action_just_pressed("Clear Link") and skills.can_link and linker_ref:
        linker_ref.clear_bodies()
    prev_is_on_floor = is_on_floor()

func kill() -> void:
    dead = true
    $Sprite2D.modulate.a = 0
    $SfxDeath.play()
    if not $SfxDeath.is_connected("finished", Globals.load_next_level):
        $SfxDeath.connect("finished", Globals.load_next_level)

func _on_timer_timeout() -> void:
    if $Sprite2D.position.y == -4:
        $Sprite2D.position.y = 0
    else:
        $Sprite2D.position.y = -4
    $WalkAnimationTimer.start()
    $WalkAnimationTimer.set_paused(true)
    

func _on_sfx_walk_timer_timeout() -> void:
    if is_on_floor():
        $SfxWalk.play()
    $SfxWalkTimer.start()


func _on_jump_cooldown_timeout() -> void:
    is_jump_ready = true;

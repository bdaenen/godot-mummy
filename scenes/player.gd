extends CharacterBody2D

signal shoot_tk_projectile(angle: Vector2)
signal shoot_link_projectile(angle: Vector2)
signal gain_telekinesis()
signal gain_link()
signal gain_sprint()

@export var linker_ref: Node2D = null

const SPEED = 230.0
const JUMP_VELOCITY = -650.0

var dimensions: Vector2 = Vector2.ZERO
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

func _ready() -> void:
    dimensions = Vector2($Sprite2D.texture.get_width() * $Sprite2D.scale.x, $Sprite2D.texture.get_height() * $Sprite2D.scale.y)
    %Player.velocity = Globals.player_spawn_velocity

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump.
    if Input.is_action_pressed("Jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
        $SfxJump.play()

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis("Left", "Right")
    if direction:
        velocity.x = direction * SPEED
        $Timer.set_paused(false)
        if $SfxWalkTimer.paused:
            $SfxWalkTimer.set_paused(false)
            if is_on_floor():
                $SfxWalk.play()
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        $Timer.set_paused(true)
        $SfxWalkTimer.stop()
        $SfxWalkTimer.start()
        $SfxWalkTimer.set_paused(true)
    move_and_slide()

func _process(_delta: float) -> void:
    if Input.is_action_pressed("Left"):
        $Sprite2D.scale.x = -1
    elif Input.is_action_pressed("Right"):
        $Sprite2D.scale.x = 1
    if is_on_floor() and not prev_is_on_floor:
        print('landed')
        # reset the walk timer
        $SfxWalkTimer.start()
        $SfxWalk.play()

    if Input.is_action_just_pressed("Shoot") and skills.can_shoot:
        shoot_tk_projectile.emit(global_position.direction_to(get_global_mouse_position()))
    if Input.is_action_just_pressed("Link") and skills.can_link:
        shoot_link_projectile.emit(global_position.direction_to(get_global_mouse_position()))
    if Input.is_action_just_pressed("Clear Link") and skills.can_link and linker_ref:
        linker_ref.clear_bodies()
    prev_is_on_floor = is_on_floor()


func _on_timer_timeout() -> void:
    if $Sprite2D.position.y == -2:
        $Sprite2D.position.y = 0
    else:
        $Sprite2D.position.y = -2
    $Timer.start()
    $Timer.set_paused(true)
    

func _on_sfx_walk_timer_timeout() -> void:
    if is_on_floor():
        $SfxWalk.play()
    $SfxWalkTimer.start()

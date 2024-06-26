extends CharacterBody2D

signal shoot_tk_projectile(angle: Vector2)
signal shoot_link_projectile(angle: Vector2)
signal gain_telekinesis()
signal gain_link()
signal gain_sprint()

@export var linker_ref: Node2D = null

const SPEED = 230.0
const JUMP_VELOCITY = -650.0

var riding_block: RigidBody2D = null;
var skills: Dictionary = {
	"can_shoot": Globals.player_skills.can_shoot,
	"can_link": Globals.player_skills.can_link,
	"can_sprint": Globals.player_skills.can_sprint
}:
	get:
		return skills

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
	%Player.velocity = Globals.player_spawn_velocity

func _physics_process(delta: float) -> void:
	if riding_block:
		velocity.x = riding_block.linear_velocity.x
		velocity.y = riding_block.linear_velocity.y

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	#var slide_collision_count: int = get_slide_collision_count()
	#if linker_ref and slide_collision_count > 0:
		#for i in slide_collision_count:
			#var collider = get_slide_collision(i).get_collider()
			#if linker_ref.linked_bodies.has(collider) and collider.linear_velocity != Vector2.ZERO:
				#riding_block = collider
			#else:
				#riding_block = null
	#else:
		#riding_block = null

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Left"):
		$Sprite2D.scale.x = -1
	if Input.is_action_pressed("Right"):
		$Sprite2D.scale.x = 1

	if Input.is_action_just_pressed("Shoot") and skills.can_shoot:
		shoot_tk_projectile.emit(global_position.direction_to(get_global_mouse_position()))
	if Input.is_action_just_pressed("Link") and skills.can_link:
		shoot_link_projectile.emit(global_position.direction_to(get_global_mouse_position()))


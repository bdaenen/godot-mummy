@tool
class_name Brick
extends AnimatableBody2D
enum BRICK_STATE { NORMAL, PARTIAL_CRACK, BROKEN }

@export var brick_state: BRICK_STATE = BRICK_STATE.NORMAL;
@export var is_active: bool = true : set = _set_is_active
@export var direction: AutoBlock.BLOCK_DIRECTION = AutoBlock.BLOCK_DIRECTION.BOTTOM : set = _set_direction, get = _get_direction
@export var flip_h: bool = false : set = _set_flip_h, get = _get_flip_h
@export var flip_v: bool = false : set = _set_flip_v, get = _get_flip_v

func _set_direction(dir: AutoBlock.BLOCK_DIRECTION) -> void:
    $AutoBlock.direction = dir
    
func _get_direction() -> AutoBlock.BLOCK_DIRECTION:
    return $AutoBlock.direction
    
func _set_flip_h(value: bool) -> void:
    $AutoBlock.flip_h = value

func _set_flip_v(value: bool) -> void:
    $AutoBlock.flip_v = value
    
func _get_flip_h() -> bool:
    return $AutoBlock.flip_h

func _get_flip_v() -> bool:
    return $AutoBlock.flip_v

func _init() -> void:
    visible = is_active
    
func _ready() -> void:
    var poly_collider_active: bool = is_active and brick_state == Brick.BRICK_STATE.BROKEN
    var rect_collider_active: bool = is_active and brick_state != Brick.BRICK_STATE.BROKEN
    
    $CollisionPolygon2D.set_deferred('disabled', !poly_collider_active)
    $CollisionShape2D.set_deferred('disabled', !rect_collider_active)
    $AutoBlock.direction = direction
    visible = is_active

func _set_is_active(value: bool) -> void:
    is_active = value
    var poly_collider_active: bool = is_active and brick_state == Brick.BRICK_STATE.BROKEN
    var rect_collider_active: bool = is_active and brick_state != Brick.BRICK_STATE.BROKEN
    
    $CollisionPolygon2D.set_deferred('disabled', !poly_collider_active)
    $CollisionShape2D.set_deferred('disabled', !rect_collider_active)
    visible = is_active

var is_linked: bool = false:
    set(value):
        var tween: Tween = create_tween()
        if value == true:
            tween.tween_method(update_shader_param, 0.0, 1.0, .5)
        else:
            tween.tween_method(update_shader_param, 1.0, 0.0, .5)
        tween.play()

func update_shader_param(val: float) -> void:
    $Sprite2D.material.set_shader_parameter("onoff",val)
    $Sprite2DCracked.material.set_shader_parameter("onoff",val)
    $WallHardPartiallyCracked.material.set_shader_parameter("onoff",val)
    $AutoBlock.material.set_shader_parameter("onoff",val)

#func _ready() -> void:
    #if cracked:
        #$Sprite2D.visible = false
    #else:
        #$Sprite2DCracked.visible = false

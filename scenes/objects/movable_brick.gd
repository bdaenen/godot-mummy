extends RigidBody2D
var is_movable: bool = true
var is_linked: bool = false:
	set(value):
		var tween: Tween = create_tween()
		tween.tween_method(update_shader_param, 0.0, 1.0, .5)
		tween.play()

func update_shader_param(val) -> void:
	$Sprite2D.material.set_shader_parameter("onoff",val)


func _process(_delta) -> void:
	if linear_velocity.abs().x + linear_velocity.abs().y < 0.2:
		linear_velocity = Vector2.ZERO

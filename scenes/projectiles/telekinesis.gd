extends Area2D
var angle: Vector2 = Vector2.ZERO
const SPEED:int = 500
var has_collided: bool = false
var disabled: bool = false
var is_telekinesis: bool = true

func _physics_process(delta: float) -> void:
    if !disabled:
        global_position += angle * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    if ("is_movable" in body and !has_collided):
        has_collided = true
        var tween: Tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(body, "position", position + angle * 75, 1)
        tween.play()
        $SfxBlockHit.play()
    _despawn()


func _on_despawn_timer_timeout() -> void:
    _despawn()

func _despawn() -> void:
    if !$SfxFire.is_playing() && !$SfxBlockHit.is_playing():
        queue_free()
    elif !disabled:
        disabled = true
        $CollisionShape2D.set_deferred('disabled', true)
        modulate.a = 0
        $SfxFire.connect("finished", queue_free)
        $SfxBlockHit.connect("finished", queue_free)

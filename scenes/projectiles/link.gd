extends Area2D
signal on_hit(body: Node2D)
var angle: Vector2 = Vector2.ZERO
var has_collided: bool = false
var disabled: bool = false
var is_link: bool = true
const SPEED:int = 500


func _physics_process(delta: float) -> void:
    if not disabled:
        global_position += angle * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    if (!has_collided):
        print(body)
        on_hit.emit(body)
        has_collided = true;
    _despawn()

func _on_despawn_timer_timeout() -> void:
    _despawn()

func _despawn() -> void:
    if !$AudioStreamPlayer.is_playing():
        queue_free()
    elif !disabled:
        disabled = true
        $CollisionShape2D.set_deferred('disabled', true)
        modulate.a = 0
        $AudioStreamPlayer.connect("finished", queue_free)

extends Area2D
signal on_hit(body: Node2D)
var angle: Vector2 = Vector2.ZERO
var has_collided: bool = false
var disabled: bool = false
var is_link: bool = true
var despawn_timer_tween: Tween = null
const SPEED:int = 500

func _ready() -> void:
    despawn_timer_tween = create_tween()
    despawn_timer_tween.tween_property($PointLight2D, "energy", 0, $DespawnTimer.wait_time)

func _physics_process(delta: float) -> void:
    if not disabled:
        global_position += angle * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
    if (!has_collided):
        on_hit.emit(body)
        has_collided = true;
    _despawn()

func _on_despawn_timer_timeout() -> void:
    _despawn()

func _despawn() -> void:
    despawn_timer_tween.stop()
    disabled = true
    $CollisionShape2D.set_deferred('disabled', true)
    modulate.a = 0
    var tween: Tween = create_tween()
    tween.tween_property($PointLight2D, "energy", 0, 0.2)
    if !$AudioStreamPlayer.is_playing():
        tween.connect('finished', func finish() -> void:
            queue_free()
        )
    elif !disabled:
        $AudioStreamPlayer.connect("finished", queue_free)

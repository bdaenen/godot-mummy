extends Area2D
class_name Warp
@export var world_coord_target: Vector2i = Vector2i(5, 1)
@export var level_spawn_position_target: Vector2 = Vector2(100, 100)

var is_active: bool = true
var triggered: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    rotation_degrees += (50 * delta)


func _on_body_entered(body: Node2D) -> void:
    if (body.is_in_group('Player') and not triggered and is_active):
        triggered = true
        var tween: Tween = body.create_tween()
        body.input_disabled = true
        Globals.warped_transition = true
        # Ideally this would live inside of the player scene/script as an animation that we can externally trigger.
        tween.set_parallel(true)
        tween.set_ease(Tween.EASE_IN)
        tween.set_trans(Tween.TRANS_CUBIC)
        tween.tween_property(body, 'global_position', global_position, 3)
        tween.tween_property(body, 'rotation_degrees', 720, 3)
        tween.tween_property(body, 'scale:x', 0.2, 3)
        tween.tween_property(body, 'scale:y', 0.2, 3)
        
        tween.play()
        $AudioStreamPlayer2D.play()


func _on_audio_stream_player_2d_finished() -> void:
    Globals.world_coord = world_coord_target
    Globals.player_spawn_position = level_spawn_position_target
    Globals.player_spawn_velocity = Vector2(0, 0)
    Globals.load_next_level()

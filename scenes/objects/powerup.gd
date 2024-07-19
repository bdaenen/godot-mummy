extends Area2D
class_name Powerup

signal picked_up(body: Node2D)

func _on_audio_stream_player_finished() -> void:
    queue_free()


func _on_body_entered(body: Node2D) -> void:
    var tween: Tween = create_tween()
    tween.tween_property($Sprite2D, 'modulate:a', 0, .5)
    tween.play()
    picked_up.emit(body)

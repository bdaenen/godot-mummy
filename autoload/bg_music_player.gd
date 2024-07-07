extends AudioStreamPlayer


func _on_finished() -> void:
    $"/root/BgMusicPlayer".play()

extends GodotLevel

func _ready() -> void:
    super()
    for child in $Floor.get_children():
        if child.has_signal('switch_press'):
            if Globals.progress_flags.left_button_pressed:
                child.set_pressed(true)
            else:
                child.connect('switch_press', func update_progress() -> void:
                    Globals.progress_flags.left_button_pressed = true
                    if Globals.progress_flags.right_button_pressed:
                        $ScreenShaker.shake(3.21, Vector2(840, 0))
                        %Player.input_disabled = true
                        $ScreenShaker.connect('shake_end', func reactivate_player() -> void:
                            %Player.input_disabled = false
                        , CONNECT_ONE_SHOT)
                )

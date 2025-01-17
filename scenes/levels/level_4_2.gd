extends GodotLevel

func _ready() -> void:
    super()
    if Globals.progress_flags.right_button_pressed:
        $Platforms/Switch.set_pressed(true)


func _on_switch_switch_press() -> void:
    if Globals.progress_flags.right_button_pressed == true:
        return
    Globals.progress_flags.right_button_pressed = true
    if Globals.progress_flags.left_button_pressed:
        $ScreenShaker.shake(3.21, Vector2(-840, 0))
        %Player.input_disabled = true
        $ScreenShaker.connect('shake_end', func reactivate_player() -> void:
            %Player.input_disabled = false
        , CONNECT_ONE_SHOT)

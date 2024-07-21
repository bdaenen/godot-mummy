extends StaticBody2D
var pressed: bool = false
signal switch_press()

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group('Player') and not pressed:
        set_pressed(true)
        $SfxSwitchClick.play()
        
func set_pressed(value: bool) -> void:
    pressed = value
    if pressed:
        $SwitchDepressed.hide()
        $SwitchPressed.show()
        $CollisionShape2D.set_deferred('disabled', true)
        switch_press.emit()
    else:
        $SwitchDepressed.show()
        $SwitchPressed.hide()

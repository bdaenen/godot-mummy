extends GodotLevel

func _ready() -> void:
    #if Globals.progress_flags.left_button_pressed and Globals.progress_flags.right_button_pressed:
        #$Pyramid.should_spawn = true
        #$BlockNextLevel.should_spawn = false
    #else:
        #$Pyramid.should_spawn = false
        #$BlockNextLevel.should_spawn = true
    super()
    $Walls/BlockNextLevel.should_spawn = !(Globals.progress_flags.left_button_pressed and Globals.progress_flags.right_button_pressed)
    $Platforms/Pyramid.should_spawn = Globals.progress_flags.left_button_pressed and Globals.progress_flags.right_button_pressed

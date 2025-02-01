class_name LevelTransition
extends Sprite2D
enum TRANSITION_SPEED { NORMAL, FAST, INSTANT }
var viewport_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var viewport_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var ratio: float = float(viewport_width) / float(viewport_height)

func _ready() -> void:
    print(ratio, ' ', viewport_width, ' ', viewport_height, ' ', viewport_width/viewport_height)
    print('x ', TRANSITION_DURATION_X)
    print('y ', TRANSITION_DURATION_Y)

var TRANSITION_DURATION_Y: Array[float] = [.5, .25, 0]
var TRANSITION_DURATION_X: Array[float] = [.5 * ratio, .23 * ratio, 0 * ratio]

@export var transition_speed: TRANSITION_SPEED = Globals.transition_speed as TRANSITION_SPEED

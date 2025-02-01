@tool
extends ggsSetting

func _init() -> void:
    value_type = TYPE_INT
    value_hint = PROPERTY_HINT_NONE
    value_hint_string = "0"
    default = 0

func apply(value: int) -> void:
    Globals.transition_speed = value

@tool
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var brick_state: Variant = $"..".brick_state
    visible = brick_state == Brick.BRICK_STATE.NORMAL
    $"../WallHardPartiallyCracked".visible = brick_state == Brick.BRICK_STATE.PARTIAL_CRACK
    $"../Sprite2DCracked".visible = brick_state == Brick.BRICK_STATE.BROKEN

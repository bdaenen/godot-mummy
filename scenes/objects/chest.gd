extends Node2D
var _was_looted: bool = false
var was_looted: bool = false : set = set_was_looted, get = get_was_looted

func set_was_looted(value: bool) -> void:
    _was_looted = value
    if (value):
        $SpriteClosed.visible = false;
        $SpriteOpened.visible = true;
        $Powerup.queue_free()

func get_was_looted() -> bool:
    return _was_looted

# Called when the node enters the scene tree for the first time.
func _on_area_2d_body_entered(_body: Node2D) -> void:
    $SpriteClosed.visible = false;
    $SpriteOpened.visible = true;
    if (not was_looted):
        $Powerup.visible = true;

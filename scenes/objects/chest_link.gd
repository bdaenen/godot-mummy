extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if (Globals.player_skills.can_link):
        $SpriteClosed.visible = false;
        $SpriteOpened.visible = true;
        $PowerupLink.queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    $SpriteClosed.visible = false;
    $SpriteOpened.visible = true;
    if (not Globals.player_skills.can_link):
        $PowerupLink.visible = true;

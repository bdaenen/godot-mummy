extends GodotLevel

func _ready() -> void:
    super()
    $Platforms/ChestTelekinesis.was_looted = Globals.player_skills.can_shoot

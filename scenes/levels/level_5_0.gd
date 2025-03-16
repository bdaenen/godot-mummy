extends GodotLevel

# Called when the node enters the scene tree for the first time.
func _init() -> void:
    minimap_position = 'left'

func _ready() -> void:
    super()
    $Platforms/ChestLink.was_looted = Globals.player_skills.can_link

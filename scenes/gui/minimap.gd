extends Control
@export var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if player:
        $MarginContainer/Background/PlayerIndicator.scale = Vector2(1, 1)
    for room in $MarginContainer/Background/Rooms.get_children():
        var split_string: PackedStringArray = room.name.split('_')
        var coord: Vector2 = Vector2(split_string[0].to_int(), split_string[1].to_int())
        if Globals.world_coord == coord:
            room.color = Color(0x00497dFF)
        elif Globals.has_visited_level(coord):
            room.color = Color(0x86660cFF)
        else:
            room.color = Color(0x000000FF)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if not player:
        return

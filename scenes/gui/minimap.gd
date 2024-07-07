extends Control
@export var player: CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for room in %Rooms.get_children():
        var split_string: PackedStringArray = room.name.split('_')
        var coord: Vector2i = Vector2i(split_string[0].to_int(), split_string[1].to_int())
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
    elif %PlayerIndicator.scale != Vector2(1, 1):
        %PlayerIndicator.scale = Vector2(1, 1)
    var active_room: ColorRect = _get_active_room_node()
    # This should be impossible, but build in a safety net anyway
    if (!active_room):
        return
    var minimap_scale: Vector2 = Vector2(%Rooms.get_child(0).size.x / Globals.viewport_bounds.x / 2, %Rooms.get_child(0).size.y / Globals.viewport_bounds.y / 2)
    %PlayerIndicator.position = active_room.position + (player.position * minimap_scale) + active_room.size/2 - %PlayerIndicator.size
    

func _get_active_room_node() -> ColorRect:
    for room in %Rooms.get_children():
        if room.name == str(Globals.world_coord.x) + '_' + str(Globals.world_coord.y):
            return room
    return null

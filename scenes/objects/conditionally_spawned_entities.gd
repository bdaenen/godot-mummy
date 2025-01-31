extends Node2D

@export var should_spawn: bool = true : set = _set_should_spawn

func _ready() -> void:
    for child in get_children():
        child.is_active = should_spawn

func _set_should_spawn(value: bool) -> void:
    should_spawn = value
    visible = should_spawn
    
    for child in get_children():
        child.is_active = should_spawn

extends Node2D

var rand: RandomNumberGenerator = RandomNumberGenerator.new()

@export var SHAKE_STRENGTH: float = 2
@export var camera: Camera2D
var shake_pattern: Array[Vector2] = []
var current_i: int = 0

func _ready() -> void:
    rand.randomize()

func shake(duration: int) -> void:
    for i in range(0, 50):
        shake_pattern.append(Vector2(rand.randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH), rand.randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH)))
    $ShakeDuration.wait_time = duration
    $ShakeDuration.start()

func _process(_delta: float) -> void:
    if shake_pattern.size():
        camera.offset = shake_pattern[current_i%shake_pattern.size()]
        current_i+=1

func _on_shake_duration_timeout() -> void:
    camera.offset = Vector2(0, 0)
    current_i = 0
    shake_pattern = []

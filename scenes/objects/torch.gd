extends Node2D
@onready var light: PointLight2D = $PointLight2D
@onready var flicker_timer: Timer = $FlickerTimer

@onready var base_energy: float = $PointLight2D.energy
var flicker_range: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $AnimatedSprite2D.play()


func _on_flicker_timer_timeout() -> void:
    var random_energy_delta: float = randf_range(-flicker_range, flicker_range)
    var tween: Tween = create_tween()
    tween.tween_property(light, "energy", base_energy + random_energy_delta, 0.1)
    tween.play()

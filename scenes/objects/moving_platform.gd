@tool
extends Path2D
@export var platform_path: Curve2D
@export var speed: float = 0.01
@export var delay: float = 1.0
var is_movable: bool = true
var _past_half:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $".".curve = platform_path
    $PauseTimer.wait_time = delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if $PauseTimer.is_stopped():
        var new_ratio: float = $PathFollow2D.progress_ratio + delta * speed
        $PathFollow2D.progress_ratio = new_ratio
        if new_ratio >= 0.5 and not _past_half:
            _past_half = true
            $PauseTimer.start()
        if new_ratio >= 1.0:
            _past_half = false
            $PauseTimer.start()

func _physics_process(_delta: float) -> void:
    $PathFollow2D/AnimatableBody2D.global_position = $PathFollow2D.global_position


func _on_pause_timer_timeout() -> void:
    $PauseTimer.stop()

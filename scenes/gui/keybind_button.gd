extends Control
class_name KeybindButton
@export var action_string_name: StringName
@export var disabled: bool
signal waiting_for_input()
signal waiting_complete()
var waiting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    %Label.text = action_string_name
    %Button.text = InputMap.action_get_events(action_string_name)[0].as_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_button_pressed() -> void:
    print('pressed')
    if disabled or waiting:
        return
    %Button.text = "Waiting for input..."
    waiting = true
    waiting_for_input.emit()

func _input(event: InputEvent) -> void:
    if not waiting or not $Timer.is_stopped():
        return
    if event is InputEventMouseButton or event is InputEventKey or event is InputEventJoypadButton:
        InputMap.action_erase_events(action_string_name)
        InputMap.action_add_event(action_string_name, event)
        %Button.text = InputMap.action_get_events(action_string_name)[0].as_text()
        $Timer.start()
        print('awaiting timer')
        await $Timer.timeout
        print('timer timed out!')
        $Timer.stop()
        waiting_complete.emit()
        waiting = false
    
    #if not InputMap.event_is_action(event):
    #    print('binding new key, ', event)
    #else:
    #    print('DUPLICATE')
    # InputMap.action_erase_events(action_string_name)

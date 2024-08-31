extends Control
class_name KeybindButton
@export var action_string_name: StringName
@export var disabled: bool
signal waiting_for_input()
signal waiting_complete()
var waiting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var regex: RegEx = RegEx.new()
    regex.compile("\\(.*\\)")
    var sanitized_label: String = regex.sub(InputMap.action_get_events(action_string_name)[0].as_text(), '', true)
    %Label.text = action_string_name
    %Button.text = sanitized_label.lstrip(' ').rstrip(' ')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_button_pressed() -> void:
    if disabled or waiting:
        return
    %Button.text = "Waiting for input..."
    waiting = true
    waiting_for_input.emit()

func _input(event: InputEvent) -> void:
    if not waiting or not $Timer.is_stopped():
        return
    
    
    var actions: Array[StringName] = InputMap.get_actions().filter(func remove_ui_keys(action: StringName) -> bool:
        return not action.begins_with('ui_')
    )
    var duplicates: Array = actions.filter(func keybind_exists(action: StringName) -> bool:
        return InputMap.action_has_event(action, event) && action != action_string_name
    )
    
    if duplicates.size():
        %Button.text = "Duplicate keybind: %s" % duplicates[0]
        self.modulate = Color.RED
    elif event is InputEventMouseButton or event is InputEventKey or event is InputEventJoypadButton:
        self.modulate = Color.WHITE
        InputMap.action_erase_events(action_string_name)
        InputMap.action_add_event(action_string_name, event)
        %Button.text = InputMap.action_get_events(action_string_name)[0].as_text()
        $Timer.start()
        await $Timer.timeout
        $Timer.stop()
        waiting_complete.emit()
        waiting = false

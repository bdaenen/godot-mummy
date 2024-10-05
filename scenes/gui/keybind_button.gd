extends Control
class_name KeybindButton
@export var action_string_name: StringName
@export var disabled: bool
@export var input_mode: int = Globals.KEYBOARD
signal waiting_for_input()
signal waiting_complete()
signal keybind_changed(action: StringName, event: InputEvent)
var waiting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var eventRegex: RegEx = RegEx.new()
    eventRegex.compile("\\(.*\\)")
    var actionNameRegex: RegEx = RegEx.new()
    actionNameRegex.compile("_controller_|_")
    
    var sanitized_label: String = eventRegex.sub(Globals.get_input_action_keyname(action_string_name, input_mode), '', true)
    %Label.text = actionNameRegex.sub(action_string_name, ' ', true).lstrip(' ').rstrip(' ')
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
    else:
        bind_new_key(event)

func bind_new_key(event: InputEvent) -> void:
    if \
      (input_mode == Globals.KEYBOARD and (event is InputEventMouseButton or event is InputEventKey)) or \
      (input_mode == Globals.JOYPAD and (event is InputEventJoypadButton or event is InputEventJoypadMotion)
    ):
        self.modulate = Color.WHITE
        # InputMap.action_erase_events(action_string_name)
        var existing_keybind: InputEvent = Globals.get_input_action_event(action_string_name, input_mode)
        if (existing_keybind):
            InputMap.action_erase_event(action_string_name, existing_keybind)
        InputMap.action_add_event(action_string_name, event)
        keybind_changed.emit(action_string_name, event)
        print(input_mode)
        %Button.text = Globals.get_input_event_keyname(event)
        $Timer.start()
        await $Timer.timeout
        $Timer.stop()
        waiting_complete.emit()
        waiting = false

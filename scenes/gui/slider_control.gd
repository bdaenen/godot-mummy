@tool
extends GridContainer
@export var label: String = 'Label'

func _ready() -> void:
    $LabelMarginContainer/Label.text = label

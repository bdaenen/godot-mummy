extends Control

var content: String = ''


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    %RichTextLabel.text = "[center]%s[/center]" % content

func set_content(new_content: String) -> void:
    content = new_content
    %RichTextLabel.text = "[center]%s[/center]" % content

func fadeIn(duration: float = .5) -> void:
    var tween = create_tween()
    tween.tween_property($".", "modulate:a", 1, duration).from(0)


func fadeOut(duration: float = .5) -> void:
    var tween = create_tween()
    tween.tween_property($".", "modulate:a", 0, duration).from(1)


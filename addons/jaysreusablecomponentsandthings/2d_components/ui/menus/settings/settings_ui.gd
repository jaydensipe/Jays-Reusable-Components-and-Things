extends Control

var _toggled: bool = false

func _ready() -> void:
	hide()
	visibility_changed.connect(func() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if _toggled else Input.MOUSE_MODE_CAPTURED
	)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_toggled = !_toggled
			show() if _toggled else hide()

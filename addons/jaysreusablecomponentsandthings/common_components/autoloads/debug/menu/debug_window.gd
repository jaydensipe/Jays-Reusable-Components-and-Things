extends Window

var _x_buffer: int = 30
var _y_buffer: int = 45

func _process(_delta: float) -> void:
	position.x = clampi(position.x, _x_buffer, (DisplayServer.window_get_size_with_decorations().x - get_size_with_decorations().x) - _x_buffer)
	position.y = clampi(position.y, _y_buffer, (DisplayServer.window_get_size_with_decorations().y - get_size_with_decorations().y) - _y_buffer)

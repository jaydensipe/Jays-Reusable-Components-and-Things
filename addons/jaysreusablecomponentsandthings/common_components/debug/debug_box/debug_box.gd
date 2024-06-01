extends MarginContainer
class_name DebugBoxContainer

@onready var label: Label = $VBoxContainer/Label
@onready var background: Panel = $Background
@onready var grid_container: GridContainer = $VBoxContainer/GridContainer

func add_button(button_text: String, functionality: Callable) -> void:
	var button: Button = Button.new()
	button.text = button_text
	button.pressed.connect(functionality)

	grid_container.add_child(button)

@tool
extends Resource
class_name DebugLabel

@export var label_text: String = "" :
	set(value):
		label_text = value
		emit_changed()
@export_color_no_alpha var label_color: Color = Color(1, 1, 1, 1) :
	set(value):
		label_color = value
		emit_changed()

@tool
extends Node
class_name DebugLabel

@export var label_text: String = "" :
	set(value):
		label_text = value
		value_changed.emit()
@export_color_no_alpha var label_color: Color = Color(1, 1, 1, 1) :
	set(value):
		label_color = value
		value_changed.emit()
@export_group("Track Values")
@export var enabled: bool = false
@export var property: String = ""

var _label: Node = null

signal value_changed

func _enter_tree() -> void:
	var parent: Node = get_parent()
	if (parent is Node2D):
		_label = Label.new()
	elif (parent is Node3D):
		_label = Label3D.new()
		_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED

	_update_label_values()
	value_changed.connect(func() -> void:
		_update_label_values()
	)

	parent.add_child.call_deferred(_label)

func _exit_tree() -> void:
	_label.queue_free()

func _physics_process(delta: float) -> void:
	if (!enabled or Engine.is_editor_hint()): return

	label_text = str(get_parent().get(property))

func _update_label_values() -> void:
	_label.text = label_text
	_label.modulate = label_color

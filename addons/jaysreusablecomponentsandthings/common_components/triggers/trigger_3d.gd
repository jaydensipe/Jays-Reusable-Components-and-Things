@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_trigger_3d.svg")
extends Area3D
class_name Trigger3D

@export_group("Debug")
@export var collision_shape: CollisionShape3D
@export var debug_label: DebugLabel

func _ready() -> void:
	_init_debug_label()

func _init_debug_label() -> void:
	if (!is_instance_valid(debug_label)): return

	assert(is_instance_valid(collision_shape), "Ensure the Collision Shape is set on this Trigger to enable proper debugging.")

	var label_3d: Label3D = Label3D.new()
	label_3d.text = debug_label.label_text
	label_3d.modulate = debug_label.label_color
	label_3d.position = collision_shape.position
	label_3d.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	if (!Engine.is_editor_hint()):
		label_3d.visible = DebugIt.is_global_debug_enabled

		# Setup signal to change label visibility based on global debug variable
		DebugIt.global_debug_changed.connect(func(value: bool) -> void: label_3d.visible = DebugIt.is_global_debug_enabled)



	add_child(label_3d)

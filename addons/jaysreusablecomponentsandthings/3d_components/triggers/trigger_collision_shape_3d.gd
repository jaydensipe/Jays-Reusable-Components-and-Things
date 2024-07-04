@tool
extends CollisionShape3D
class_name TriggerShape3D

@export_group("Debug")
@export var debug_label: DebugLabel

var _mesh: MeshInstance3D = null
var _label: Label3D = null
const TRIGGER_MATERIAL = preload("res://addons/jaysreusablecomponentsandthings/assets/materials/triggers/trigger_material.tres")

func _ready() -> void:
	if (!is_instance_valid(shape)): return

	_init_and_update_debug()

	#debug_label.changed.connect(func() -> void:
		#_update_debug_label()
	#)

func _set(property: StringName, value: Variant) -> bool:
	if (property == "shape"):
		if (is_instance_valid(value)):
			_init_and_update_debug()
		else:
			_mesh.queue_free()
			_label.queue_free()

	return false

func _notification(what: int) -> void:
	match (what):
		44:
			_update_debug_mesh()

func _init_and_update_debug() -> void:
	_init_debug_label()
	_update_debug_label()

	if (Engine.is_editor_hint()):
		_init_debug_mesh()
		_update_debug_mesh()

func _differentiate_trigger_texture() -> CompressedTexture2D:
	if (get_parent_node_3d() is TriggerSoundscape):
		return preload("res://addons/jaysreusablecomponentsandthings/assets/materials/triggers/trigger_soundscape_texture.png")
	if (get_parent_node_3d() is TriggerTeleport):
		return preload("res://addons/jaysreusablecomponentsandthings/assets/materials/triggers/trigger_teleport_texture.png")
	else:
		return preload("res://addons/jaysreusablecomponentsandthings/assets/materials/triggers/trigger_texture.png")

func _init_debug_mesh() -> void:
	_mesh = MeshInstance3D.new()
	_mesh.mesh = BoxMesh.new()
	_mesh.material_override = TRIGGER_MATERIAL.duplicate()
	_mesh.material_override.albedo_texture = _differentiate_trigger_texture()

	add_child(_mesh)

func _update_debug_mesh() -> void:
	if (!is_instance_valid(_mesh)): return

	_mesh.mesh.size = shape.size

func _init_debug_label() -> void:
	if (!is_instance_valid(debug_label)): return

	_label = Label3D.new()
	_label.global_position = to_local(global_position)
	_label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y

	if (!Engine.is_editor_hint()):
		_label.visible = DebugIt.is_global_debug_enabled

		# Setup signal to change label visibility based on global debug variable
		DebugIt.global_debug_changed.connect(func(value: bool) -> void: _label.visible = value)

	add_child(_label)

func _update_debug_label() -> void:
	if (!is_instance_valid(_label)): return

	_label.text = debug_label.label_text
	_label.modulate = debug_label.label_color

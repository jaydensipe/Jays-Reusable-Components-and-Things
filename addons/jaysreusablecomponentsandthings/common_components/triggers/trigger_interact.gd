@tool
extends Trigger3D
class_name TriggerInteract

@export var node: Node = null
@export_group("Methods")
@export var method_to_call: String = ""
@export_subgroup("Toggle")
@export var toggleable: bool = false
@export var on_method: String = ""
@export var off_method: String = ""
var _toggled: bool = false

func _ready() -> void:
	assert(is_instance_valid(node), "Ensure the Node export is set on this Trigger Interact.")

func pressed() -> void:
	if (toggleable):
		if (_toggled):
			_toggled = false
			node.propagate_call(off_method)
		else:
			_toggled = true
			node.propagate_call(on_method)
	else:
		node.propagate_call(method_to_call)

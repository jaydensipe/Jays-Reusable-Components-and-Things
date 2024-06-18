@tool
extends Trigger3D
class_name TriggerTeleport

@export var marker: Marker3D = null
@export_enum("BodyEntered", "BodyExited") var trigger_type: int = 0

func _ready() -> void:
	super()

	assert(is_instance_valid(marker), "Ensure the Marker export is set on this Trigger Teleport.")

	if (trigger_type == 0):
		body_entered.connect(func(body: Node3D) -> void:
			body.global_position = marker.global_position
		)
	else:
		body_exited.connect(func(body: Node3D) -> void:
			body.global_position = marker.global_position
		)

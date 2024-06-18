@tool
extends Trigger3D
class_name TriggerSceneChange

@export var scene: PackedScene
@export_enum("BodyEntered", "BodyExited") var trigger_type: int = 0

func _ready() -> void:
	super()

	if (trigger_type == 0):
		body_entered.connect(func(body: Node3D) -> void:
			SceneIt.load_packed_scene(scene)
		)
	else:
		body_exited.connect(func(body: Node3D) -> void:
			SceneIt.load_packed_scene(scene)
		)

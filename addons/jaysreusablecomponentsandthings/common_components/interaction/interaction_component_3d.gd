extends Node3D
class_name InteractionComponent3D

@export var camera_3d: Camera3D
var _ray_hit: Dictionary = {}

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event.keycode == KEY_E and event.pressed):
			if (!_ray_hit.is_empty() and _ray_hit["collider"] is TriggerInteract):
				_ray_hit["collider"].pressed()

func _physics_process(delta: float) -> void:
	_ray_hit = RaycastIt.ray_from_camera_3d(2.5, camera_3d, true, 0.01, [owner], true, true)

extends Node3D
class_name InteractionComponent3D

@export var camera_3d: Camera3D
var _ray_hit: Dictionary = {}
var _hovering_interactable: bool = false
var _current_hovered_interactable: TriggerInteract = null

signal hovered_interactable(interactable: TriggerInteract)
signal stopped_hovering(interactable: TriggerInteract)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if (event.keycode == KEY_E and event.pressed):
			if (!_ray_hit.is_empty() and _ray_hit["collider"] is TriggerInteract):
				_ray_hit["collider"].pressed()

func _physics_process(delta: float) -> void:
	_ray_hit = RaycastIt.ray_from_camera_3d(2.5, camera_3d, true, 0.01, [owner], true, true)

	if (!_ray_hit.is_empty() and _ray_hit["collider"] is TriggerInteract):
		_hovering_interactable = true

		if (!is_instance_valid(_current_hovered_interactable)):
			hovered_interactable.emit(_current_hovered_interactable)

		_current_hovered_interactable = _ray_hit["collider"]
	else:
		if (is_instance_valid(_current_hovered_interactable)):
			stopped_hovering.emit(_current_hovered_interactable)

		_current_hovered_interactable = null
		_hovering_interactable = false

func is_hovering_interactable() -> bool:
	return _hovering_interactable

func get_current_hovered_interactable() -> TriggerInteract:
	return _current_hovered_interactable

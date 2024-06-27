extends Node3D
class_name ReverbHandlerComponent3D

@export var max_raycasts: int = 12
@export var max_ray_range: float = 1000.0
@export var max_reverb_wetness: float = 0.5
@export var show_debug: bool = false
var _hit_lengths: PackedFloat32Array = []

func _ready() -> void:
	_hit_lengths.resize(max_raycasts)

func _physics_process(delta: float) -> void:
	for i in range(max_raycasts):
		var result: Dictionary = RaycastIt.ray_3d(global_transform, Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(randf_range(-360, 360))).rotated(Vector3.LEFT, deg_to_rad(randf_range(-360, 360))), max_ray_range, show_debug, 0.1)

		if (result):
			_hit_lengths[i] = global_position.distance_squared_to(result["position"])
		else:
			_hit_lengths[i] = -1

	var average_hit_range: float = 0.0
	var room_size: float = 0.0
	var wetness: float = 1.0
	for length: float in _hit_lengths:
		if (length != -1):
			room_size += (length / max_ray_range) / float(_hit_lengths.size()) * 0.7
			room_size = min(room_size, 1.0)
		else:
			wetness -= 3.0 / float(_hit_lengths.size())
			wetness = max(wetness, 0.0)
		average_hit_range += length

	(AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet =  lerp((AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet, wetness * max_reverb_wetness, delta * 5.0)
	(AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).room_size =  lerp((AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).room_size, room_size, delta * 5.0)

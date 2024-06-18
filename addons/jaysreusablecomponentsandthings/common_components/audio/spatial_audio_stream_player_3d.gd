extends AudioStreamPlayer3D
class_name SpatialAudioStreamPlayer3D

# Created with help from https://youtu.be/mHokBQyB_08. Thanks!

@export_enum("Spatial", "Soundscape") var sound_type: int = 0
@export_enum("Single Raycast", "Multi-Raycast") var occlusion_type: int = 0
@onready var bus_index: int = AudioServer.bus_count
@onready var bus_name: StringName = "SpatialBus#%d" % bus_index
@onready var single_raycast_3d: RayCast3D

func _ready() -> void:
	match (sound_type):
		0:
			_init_bus()
			if (occlusion_type == 0):
				_init_single_ray()
		1:
			attenuation_model = ATTENUATION_DISABLED
			panning_strength = 0.0

func _physics_process(delta: float) -> void:
	if (sound_type == 1): return

	match (occlusion_type):
		0:
			_process_single_ray()
		1:
			_process_multi_ray()

func _init_bus() -> void:
	AudioServer.add_bus(bus_index)
	AudioServer.set_bus_name(bus_index, bus_name)
	AudioServer.set_bus_send(bus_index, bus)
	AudioServer.add_bus_effect(bus_index, AudioEffectLowPassFilter.new(), 0)
	AudioServer.set_bus_effect_enabled(bus_index, 0, false)

	bus = bus_name

func _init_single_ray() -> void:
	single_raycast_3d = RayCast3D.new()

	add_child(single_raycast_3d)

func _process_single_ray() -> void:
	var single_ray_target_pos: Vector3 = to_local(get_viewport().get_camera_3d().global_position)
	single_raycast_3d.target_position = single_ray_target_pos

	if (single_raycast_3d.is_colliding()):
		var _min_cutoff: float = 5000.0

		AudioServer.set_bus_effect_enabled(bus_index, 0, true)
		(AudioServer.get_bus_effect(bus_index, 0) as AudioEffectLowPassFilter).cutoff_hz = max(1000, _min_cutoff - (single_raycast_3d.get_collision_point().distance_squared_to(to_local(get_viewport().get_camera_3d().global_position))) * 20.0)
	elif (AudioServer.is_bus_effect_enabled(bus_index, 0)):
		AudioServer.set_bus_effect_enabled(bus_index, 0, false)

func _process_multi_ray() -> void:
	var cam_position: Vector3 = to_local(get_viewport().get_camera_3d().global_position)
	RaycastIt.ray_3d(global_transform, cam_position, 1.0, true, 0.01)

	var left_model: Transform3D = global_transform
	left_model.origin = global_transform.origin + -global_transform.basis.x
	RaycastIt.ray_3d(left_model, cam_position, 1.0, true, 0.01)

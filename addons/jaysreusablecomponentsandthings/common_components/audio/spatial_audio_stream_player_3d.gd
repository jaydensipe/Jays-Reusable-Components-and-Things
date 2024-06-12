extends AudioStreamPlayer3D
class_name SpatialAudioStreamPlayer3D

@export_enum("Spatial", "Soundscape") var sound_type = 0
@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _physics_process(delta: float) -> void:
	ray_cast_3d.target_position =  to_local(get_viewport().get_camera_3d().global_position)
	#if (ray_cast_3d.is_colliding()):
		#AudioServer.set_bus_effect_enabled(1, 0, true)
		#i9
	#else:
		#AudioServer.set_bus_effect_enabled(1, 0, false)


	if (get_viewport().get_camera_3d().is_inside):
		(AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet =  lerp((AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet, get_viewport().get_camera_3d().outsideness / 3, delta * 1.1)
		AudioServer.set_bus_effect_enabled(0, 0, true)

		bus = &"OutdoorFromIndoor"
	else:
		if (sound_type == 1 and !get_viewport().get_camera_3d().is_inside):
			(AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet = lerp((AudioServer.get_bus_effect(0, 0) as AudioEffectReverb).wet, 0.0, delta * 1.1)
		bus = &"Master"

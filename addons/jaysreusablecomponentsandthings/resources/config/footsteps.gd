extends Resource
class_name Footsteps

@export var distance_between_steps: float = 60
@export_node_path("AudioStreamPlayer3D") var footstep_audio
@export_node_path("AudioStreamPlayer3D") var jump_audio
@export_node_path("AudioStreamPlayer3D") var land_audio

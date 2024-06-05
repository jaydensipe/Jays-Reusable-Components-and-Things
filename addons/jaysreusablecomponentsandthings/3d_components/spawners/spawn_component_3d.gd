extends Node3D
class_name SpawnComponent3D

@export_group("Config")
@export var spawn_delay_timer: bool = false
@export_range(0, 60, 0.1, "suffix:s") var spawn_delay_time: float = 0.0
@export var delete_timer: bool = false
@export_range(0, 60, 0.1, "suffix:s") var delete_time: float = 0.0

@export_subgroup("Randomization")
@export var randomize_x: bool = false
@export var randomize_y: bool = false
@export var randomize_z: bool = false

func spawn_at_location(spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene):
	pass

func spawn_at_location_with_transform(spawn_transform: Transform3D = global_transform, parent: Node = get_tree().current_scene):
	pass

func spawn_at_location_with_normal(normal: Vector3, spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene):
	pass

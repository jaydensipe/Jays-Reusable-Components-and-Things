@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_scene_spawn_component_3d.svg")
extends Marker3D
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

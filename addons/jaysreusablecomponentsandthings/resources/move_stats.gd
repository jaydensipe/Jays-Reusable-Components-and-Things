extends Resource
class_name MoveStats

@export var speed: float = 10.0
@export var jump_height: float = 5.0

@export_group("Advanced Config")
@export var apply_acceleration: bool = false
@export var acceleration: float = 10.0
@export var apply_air_acceleration: bool = false
@export var air_acceleration: float = 2.0

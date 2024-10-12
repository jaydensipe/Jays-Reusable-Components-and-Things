extends Resource
class_name CameraConfig

@export var mouse_sensitivity: float = 3.0

@export_subgroup("Roll Config")
@export var enable_roll: bool = false
@export var roll_amount: float = 30.0
@export var roll_speed: float = 125.0

@export_subgroup("Bob Config")
@export var enable_bob: bool = false
@export var bob_frequency: float = 2.0
@export var bob_amplitude: float = 0.08

@export_subgroup("Sprint Config")
@export var change_amount: float = 5.0
@export var change_speed: float = 2.0

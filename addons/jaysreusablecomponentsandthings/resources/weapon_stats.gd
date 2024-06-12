extends Resource
class_name WeaponStats

@export var fire_rate: float = 1.0
@export var max_ammo: float = 6.0
var ammo: float = 6.0

func _init() -> void:
	# Ensures variables are ready
	call_deferred("_ready")

func _ready() -> void:
	ammo = max_ammo

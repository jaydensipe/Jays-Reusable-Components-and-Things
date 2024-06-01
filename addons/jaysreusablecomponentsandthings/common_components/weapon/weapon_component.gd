extends Node
class_name WeaponComponent

@export var _weapon_stats: WeaponStats
@export var _weapon_binds: WeaponBinds

signal reload_pressed()
signal primary_pressed()
signal alternate_pressed()
signal primary_stopped_pressing()
signal alternate_stopped_pressing()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("reload")):
		reload_pressed.emit()

	if (event.is_action_pressed("primary")):
		primary_pressed.emit()

	if (event.is_action_pressed("alternate")):
		alternate_pressed.emit()

	if (event.is_action_pressed("primary")):
		primary_stopped_pressing.emit()

	if (event.is_action_pressed("alternate")):
		alternate_stopped_pressing.emit()

func get_stats() -> WeaponStats:
	return _weapon_stats

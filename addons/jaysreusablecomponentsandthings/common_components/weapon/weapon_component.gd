@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_weapon_component.svg")
extends Node
class_name WeaponComponent

@export var _weapon_stats: WeaponStats
@export var _weapon_binds: WeaponBinds
var _primary_held: bool = false
var _alternate_held: bool = false

signal primary_pressed()
signal alternate_pressed()
signal reload_pressed()
signal primary_stopped_pressing()
signal alternate_stopped_pressing()

func _physics_process(_delta: float) -> void:
	if (_primary_held):
		primary_pressed.emit()

	if (_alternate_held):
		alternate_pressed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed(_weapon_binds.primary)):
		_primary_held = true

	if (event.is_action_pressed(_weapon_binds.alternate)):
		_alternate_held = true

	if (event.is_action_pressed(_weapon_binds.reload)):
		reload_pressed.emit()

	if (event.is_action_released(_weapon_binds.primary)):
		primary_stopped_pressing.emit()
		_primary_held = false

	if (event.is_action_released(_weapon_binds.alternate)):
		alternate_stopped_pressing.emit()
		_alternate_held = false

func get_stats() -> WeaponStats:
	return _weapon_stats

func get_binds() -> WeaponBinds:
	return _weapon_binds

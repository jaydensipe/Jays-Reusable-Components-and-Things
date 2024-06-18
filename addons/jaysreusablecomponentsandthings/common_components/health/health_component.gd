@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_health_component.svg")
extends Node
class_name HealthComponent
## A component for adding health specific functionality to a [Node].

enum HEALTH_TYPES {
	HEAL,
	DAMAGE
}

var _is_dead: bool = false
@export var max_health: float = 1.0
@export var _health: float = 1.0:
	set(value):
		_health = clampf(value, 0.0, max_health)

		# Sends signal when health value changes
		on_health_changed.emit(value)

		if (_health <= 0.0):
			on_death.emit()
			_is_dead = true

@export_category("Flags")
@export var invincible: bool = false

func _ready() -> void:
	_health = max_health

func apply_health(health_value: float, type: HEALTH_TYPES)  -> void:
	match type:
		HEALTH_TYPES.DAMAGE:
			if (_health <= 0.0 or invincible): return

			_health -= absi(health_value)
		HEALTH_TYPES.HEAL:
			_health += absi(health_value)

			if (_health == max_health):
				on_healed_to_full.emit()
		_:
			printerr("Type not specified for HealthComponent.")

func reset_health() -> void:
	_health = max_health

func is_dead() -> bool:
	return _is_dead

signal on_health_changed(health: float)
signal on_healed_to_full()
signal on_death()

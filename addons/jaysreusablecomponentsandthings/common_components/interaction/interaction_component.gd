@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_interaction_component_3d.svg")
extends Node
class_name InteractionComponent

@export var _interact_binds: InteractBinds
var _hovering_interactable: bool = false
var _current_hovered_interactable: TriggerInteract = null

signal hovered_interactable(interactable: TriggerInteract)
signal stopped_hovering(interactable: TriggerInteract)

func is_hovering_interactable() -> bool:
	return _hovering_interactable

func get_current_hovered_interactable() -> TriggerInteract:
	return _current_hovered_interactable

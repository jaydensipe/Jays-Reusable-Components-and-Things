extends Node
class_name InteractionBase

var _hovering_interactable: bool = false
var _current_hovered_interactable: TriggerInteract = null

@warning_ignore("unused_signal")
signal hovered_interactable(interactable: TriggerInteract)
@warning_ignore("unused_signal")
signal stopped_hovering(interactable: TriggerInteract)

func is_hovering_interactable() -> bool:
	return _hovering_interactable

func get_current_hovered_interactable() -> TriggerInteract:
	return _current_hovered_interactable

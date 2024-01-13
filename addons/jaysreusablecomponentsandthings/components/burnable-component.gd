extends Node
class_name BurnableComponent

@export var actor: Node
@export var burn_stats: BurnStats

func start_burn() -> void:
	#TODO: Add burning shader
	get_tree().create_timer(burn_stats.burn_time).timeout.connect(_burn)
	
func _burn() -> void:
	actor.queue_free()

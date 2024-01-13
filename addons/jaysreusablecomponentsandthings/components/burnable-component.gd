extends Node
class_name BurnableComponent

@export var actor: Node
@export var burn_stats: BurnStats

func _ready() -> void:
	get_tree().create_timer(burn_stats.burn_time).timeout.connect(func(): actor.queue_free())

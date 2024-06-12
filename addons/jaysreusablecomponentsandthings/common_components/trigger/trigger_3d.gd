@tool
extends Area3D
class_name Trigger3D

@export var label_debug: String = ""
@export var node: Node = null
@export var triggers: Array[TriggerEffect]
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	var label_3d: Label3D = Label3D.new()
	label_3d.text = label_debug
	label_3d.position = collision_shape_3d.position

	for trigger: TriggerEffect in triggers:
		if (trigger.trigger_type == 0):
			body_entered.connect(func(body: Node3D):
				body.propagate_call(trigger.method_to_call)
			)
		elif (trigger.trigger_type == 1):
			body_exited.connect(func(body: Node3D):
				body.propagate_call(trigger.method_to_call)
			)

	add_child(label_3d)

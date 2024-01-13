extends CharacterBody3D

@onready var move_component_3d: MoveComponent3D = $MoveComponent3D
@export var move_stats: MoveStats
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		move_component_3d.velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_component_3d.velocity.y = move_stats.jump_height

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		move_component_3d.velocity.x = direction.x * move_stats.movement_speed
		move_component_3d.velocity.z = direction.z * move_stats.movement_speed
	else:
		move_component_3d.velocity.x = move_toward(move_component_3d.velocity.x, 0, move_stats.movement_speed)
		move_component_3d.velocity.z = move_toward(move_component_3d.velocity.z, 0, move_stats.movement_speed)

	move_and_slide()

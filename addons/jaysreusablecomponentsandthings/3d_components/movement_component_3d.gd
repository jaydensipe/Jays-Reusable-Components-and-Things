extends Node3D
class_name MovementComponent3D

@export var character: CharacterBody3D
@export var move_stats: MoveStats
@export_group("Advanced Config")
@export_subgroup("Player")
@export var is_player_controlled: bool = false
@export_placeholder("Set in Project Settings") var move_forward_name: String = ""
@export_placeholder("Set in Project Settings") var move_backward_name: String = ""
@export_placeholder("Set in Project Settings") var move_left_name: String = ""
@export_placeholder("Set in Project Settings") var move_right_name: String = ""
@export_placeholder("Set in Project Settings") var jump_name: String = ""

@export_group("Flags")
@export var disable_movement: bool = false

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _direction: Vector3 = Vector3.ZERO
var _input_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	assert(is_instance_valid(character), "Please provide CharacterBody3D to the CharacterMovement3D component!")
	assert(is_instance_valid(move_stats), "Please provide MoveStats to the CharacterMovement3D component!")

func _physics_process(delta: float) -> void:
	# Apply player movement
	if (is_player_controlled):
		apply_player_input_direction()
		
	# Checks for jump
	if (is_player_controlled and Input.is_action_just_pressed(jump_name)):
		jump()
	
	# Add the gravity
	if not character.is_on_floor():
		character.velocity.y -= _gravity * delta
		
	# Disabled movement flag
	if (disable_movement):
		_input_dir = Vector2.ZERO
	
	# Checks for applying acceleration
	if (move_stats.apply_acceleration):
		_direction = lerp(_direction, (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized(), delta * move_stats.acceleration)
	else:
		_direction = (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
		
	# Checks for applying air acceleration
	if character.is_on_floor():
		if _direction:
			character.velocity.x = _direction.x * move_stats.speed
			character.velocity.z = _direction.z * move_stats.speed
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, move_stats.speed)
			character.velocity.z = move_toward(character.velocity.z, 0, move_stats.speed)
	elif move_stats.apply_air_acceleration:
		character.velocity.x = lerp(character.velocity.x, _direction.x * move_stats.speed, delta * move_stats.air_acceleration)
		character.velocity.z = lerp(character.velocity.z, _direction.z * move_stats.speed, delta * move_stats.air_acceleration)
		
	character.move_and_slide()
	
func apply_player_input_direction():
	_input_dir = Input.get_vector(move_left_name, move_right_name, move_forward_name, move_backward_name)
	
func jump():
	# Disabled movement flag
	if (disable_movement): return
	
	if character.is_on_floor():
		character.velocity.y = move_stats.jump_height
	
func move_to_direction(direction: Vector3, delta: float):
	direction = direction.normalized()
	
	character.velocity = character.velocity.lerp(direction * move_stats.speed, move_stats.acceleration * delta)
	character.move_and_slide()


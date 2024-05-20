extends Node3D
class_name MovementComponent3D

@export var character: CharacterBody3D
@export var collider: CollisionShape3D
@export var move_stats: MoveStats

@export_group("Footsteps")
@export var footstep_audio_player: AudioStreamPlayer3D

@export_group("Advanced Config")
@export_subgroup("Player")
@export var is_player_controlled: bool = false
@export_placeholder("Set in Project Settings") var move_forward_name: String = ""
@export_placeholder("Set in Project Settings") var move_backward_name: String = ""
@export_placeholder("Set in Project Settings") var move_left_name: String = ""
@export_placeholder("Set in Project Settings") var move_right_name: String = ""
@export_subgroup("Jump Config")
@export var enable_jumping: bool = true
@export_placeholder("Set in Project Settings") var jump_name: String = ""
@export_subgroup("Sprint Config")
@export var enable_sprinting: bool = true
@export_placeholder("Set in Project Settings") var sprint_name: String = ""
@export_subgroup("Crouch Config")
@export var enable_crouching: bool = true
@export_placeholder("Set in Project Settings") var crouch_name: String = ""

@export_group("Flags")
@export var disable_movement: bool = false

enum MOVEMENT_STATES {
	WALKING,
	SPRINTING,
	JUMPING,
	CROUCHING
}
var _current_movement: MOVEMENT_STATES = MOVEMENT_STATES.WALKING
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _direction: Vector3 = Vector3.ZERO
var _input_dir: Vector2 = Vector2.ZERO
var _debugger_index: int = 0
@onready var _current_max_move_speed: float = move_stats.speed

func _ready() -> void:
	assert(is_instance_valid(character), "Please provide CharacterBody3D to the CharacterMovement3D component!")
	assert(is_instance_valid(collider), "Please provide CollisionShape3D to the CharacterMovement3D component!")
	assert(is_instance_valid(move_stats), "Please provide MoveStats to the CharacterMovement3D component!")
	
	DebugIt.register_section("%s -> %s" % [get_parent().name, self.name], self, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_movement_component_3d.svg"))

func _physics_process(delta: float) -> void:
	# Disable movement check
	if (disable_movement): return
	
	# Apply player movement
	if (is_player_controlled):
		apply_player_input_direction()
		
	# Checks for jump
	if (is_player_controlled and Input.is_action_just_pressed(jump_name) and enable_jumping):
		jump()
		
	# Checks for sprint
	if (is_player_controlled and Input.is_action_pressed("sprint") and enable_sprinting):
		sprint()
	else:
		reset_to_walk()
		
	# Checks for crouch
	if (is_player_controlled and Input.is_action_pressed("crouch") and enable_crouching):
		crouch(delta)
	else:
		stop_crouch(delta)
	
	# Add the gravity
	if not character.is_on_floor():
		character.velocity.y -= _gravity * delta
		
	# Disabled movement flag
	if (disable_movement):
		_input_dir = Vector2.ZERO
		
	apply_movement(delta)

func apply_movement(delta: float): 	
	# Checks for applying acceleration
	if (move_stats.apply_acceleration):
		_direction = lerp(_direction, (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized(), delta * move_stats.acceleration)
	else:
		_direction = (character.transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
		
	# Checks for applying air acceleration
	if character.is_on_floor():
		if _direction:
			character.velocity.x = _direction.x * _current_max_move_speed
			character.velocity.z = _direction.z * _current_max_move_speed
		else:
			character.velocity.x = move_toward(character.velocity.x, 0, _current_max_move_speed)
			character.velocity.z = move_toward(character.velocity.z, 0, _current_max_move_speed)
			
	elif move_stats.apply_air_acceleration:
		character.velocity.x = lerp(character.velocity.x, _direction.x * _current_max_move_speed, delta * move_stats.air_acceleration)
		character.velocity.z = lerp(character.velocity.z, _direction.z * _current_max_move_speed, delta * move_stats.air_acceleration)
	
	character.move_and_slide()
	
func apply_player_input_direction():
	_input_dir = Input.get_vector(move_left_name, move_right_name, move_forward_name, move_backward_name)
	
func jump():
	if character.is_on_floor():
		_current_movement = MOVEMENT_STATES.JUMPING
		character.velocity.y = move_stats.jump_height
		
func sprint():
	if (character.is_on_floor() and _current_movement != MOVEMENT_STATES.CROUCHING):
		_current_movement = MOVEMENT_STATES.SPRINTING
		_current_max_move_speed = move_stats.speed * move_stats.sprint_multiplier
		
func crouch(delta: float):
	_current_movement = MOVEMENT_STATES.CROUCHING
	collider.shape.set_height(lerpf(collider.shape.get_height(), 1.25, 7.5 * delta))
	_current_max_move_speed = move_stats.speed * move_stats.crouch_multiplier
	
func stop_crouch(delta: float):
	collider.shape.set_height(lerpf(collider.shape.get_height(), 2.0, 7.5 * delta))
	
func reset_to_walk():
	_current_max_move_speed = move_stats.speed
	_current_movement = MOVEMENT_STATES.WALKING
	
func move_to_direction(direction: Vector3, delta: float):
	direction = direction.normalized()
	
	character.velocity = character.velocity.lerp(direction * _current_max_move_speed, move_stats.acceleration * delta)
	character.move_and_slide()


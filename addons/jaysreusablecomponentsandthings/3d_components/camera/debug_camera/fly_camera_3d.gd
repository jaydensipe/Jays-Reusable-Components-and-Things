class_name FlyCamera extends Camera3D

# Used from https://github.com/adamviola/simple-free-look-camera/blob/master/camera.gd. Thank you!

@export_range(0.0, 1.0) var sensitivity: float = 0.25
var _prev_camera: Camera3D = null
var _mouse_position: Vector2 = Vector2(0.0, 0.0)
var _total_pitch: float = 0.0
var _direction: Vector3 = Vector3(0.0, 0.0, 0.0)
var _velocity: Vector3 = Vector3(0.0, 0.0, 0.0)
var _acceleration: float = 30.0
var _deceleration: float = -10.0
var _vel_multiplier: float = 4.0
var _shift: bool = false
var _alt: bool = false

const SHIFT_MULTIPLIER: float = 2.5

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

func _exit_tree() -> void:
	_prev_camera.make_current()

func _unhandled_input(event: InputEvent) -> void:
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative

	# Receives mouse button input
	if (event is InputEventMouseButton):
		match (event.button_index):
			MOUSE_BUTTON_WHEEL_UP: # Increases max velocity
				_vel_multiplier = clamp(_vel_multiplier * 1.1, 0.2, 20)
			MOUSE_BUTTON_WHEEL_DOWN: # Decereases max velocity
				_vel_multiplier = clamp(_vel_multiplier / 1.1, 0.2, 20)

	# Receives key input
	if (event is InputEventKey):
		match (event.keycode):
			KEY_SHIFT:
				_shift = event.pressed
			KEY_ALT:
				_alt = event.pressed

func _process(delta: float) -> void:
	_update_movement(delta)
	_update_mouselook()

func _update_movement(delta: float) -> void:
	# Computes desired direction from key states
	var input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	_direction = Vector3(input.x, 0.0, input.y)

	# Computes the change in velocity due to desired direction and "drag"
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	var offset: Vector3 = _direction.normalized() * _acceleration * _vel_multiplier * delta + _velocity.normalized() * _deceleration * _vel_multiplier * delta

	# Compute modifiers' speed multiplier
	var speed_multi: float = 1.0
	if (_shift): speed_multi *= SHIFT_MULTIPLIER
	if (_alt): speed_multi *= 0.0

	# Checks if we should bother translating the camera
	if (_direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared()):
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_velocity = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_multiplier)
		_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		_velocity.y = clamp(_velocity.y + offset.y, -_vel_multiplier, _vel_multiplier)
		_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)

		translate(_velocity * delta * speed_multi)

func _update_mouselook() -> void:
	if (_alt): return

	# Only rotates mouse if the mouse is captured
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		_mouse_position *= sensitivity
		var yaw: float = _mouse_position.x
		var pitch: float = _mouse_position.y
		_mouse_position = Vector2(0, 0)

		# Prevents looking up/down too far
		pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
		_total_pitch += pitch

		rotate_y(deg_to_rad(-yaw))
		rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

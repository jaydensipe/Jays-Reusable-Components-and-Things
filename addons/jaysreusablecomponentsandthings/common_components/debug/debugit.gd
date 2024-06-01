extends Control

@export var debug_name: String
@onready var window: Window = $Window
@onready var inspector: Inspector = $Window/TabContainer/Inspector
@onready var debug: FlowContainer = $Window/TabContainer/Debug
@onready var monitor: Panel = $"Window/TabContainer/System Monitor"

var _position
var _debug_fly_cam_3d: FlyCamera = null

const DEBUG_BOX_CONTAINER = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/debug_box/debug_box_container.tscn")
const MONITOR: PackedScene = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/monitor/monitor.tscn")

func _ready() -> void:
	_position = Vector2(get_viewport().get_window().size.x / 1.5, get_viewport().get_window().size.y / 10)
	monitor.add_child(MONITOR.instantiate())

	_init_default_debug_box_functionality()

func register_in_inspector(node: Node, icon: Texture2D = inspector._fallback_icon) -> void:
	if (icon == null): icon = inspector._fallback_icon

	inspector._register_inspector(node, icon)

func _init_default_debug_box_functionality() -> void:
	var built_ins_box: DebugBoxContainer = create_debug_box("Built-Ins")
	built_ins_box.add_button("Switch Render Views", func():
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 6
	)
	built_ins_box.add_button("Toggle Fullscreen", func():
		if (DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	)
	built_ins_box.add_button("Toggle Fly Camera (3D)", func():
		if (is_instance_valid(_debug_fly_cam_3d)):
			_debug_fly_cam_3d._prev_camera.make_current()
			_debug_fly_cam_3d.queue_free()
			return
		_debug_fly_cam_3d = FlyCamera.new()
		get_tree().current_scene.add_child(_debug_fly_cam_3d)

		var _current_cam: Camera3D = get_viewport().get_camera_3d()
		_debug_fly_cam_3d.global_transform = _current_cam.global_transform
		_debug_fly_cam_3d._prev_camera = _current_cam
		_debug_fly_cam_3d.make_current()
	)
	built_ins_box.add_button("Toggle Debug", func():
		pass
	)
	built_ins_box.add_button("Pause Game", func():
		get_tree().paused = !get_tree().paused
	)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed(debug_name)):
		if (!window.visible):
			window.visible = true

		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func create_debug_box(title: StringName, background_color: Color = Color.GRAY) -> DebugBoxContainer:
	for debug_box: DebugBoxContainer in debug.get_children():
		if (debug_box.label.text == title):
			return debug_box

	var debug_box_container: DebugBoxContainer = DEBUG_BOX_CONTAINER.instantiate()
	debug_box_container.ready.connect(func():
		debug_box_container.label.text = title

		var style_box: StyleBox = debug_box_container.background.get_theme_stylebox("panel").duplicate()
		style_box.set("bg_color", background_color)
		debug_box_container.background.add_theme_stylebox_override("panel", style_box)
	)

	debug.add_child(debug_box_container)

	return debug_box_container

func _on_window_close_requested() -> void:
	window.visible = false

func _on_window_focus_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_window_window_input(event: InputEvent) -> void:
	if (event.is_action_pressed(debug_name)):
		window.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_window_visibility_changed() -> void:
	if (window == null): return

	if (window.visible):
		window.position = _position

	_position = window.position

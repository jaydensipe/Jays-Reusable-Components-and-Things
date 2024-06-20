extends Control

@onready var window: Window = $Window
@onready var tab_container: TabContainer = $Window/TabContainer
@onready var inspector: Inspector = $Window/TabContainer/Inspector
@onready var debug: FlowContainer = $Window/TabContainer/Debug
@onready var monitor: Panel = $"Window/TabContainer/System Monitor"
@onready var _target_position: Vector2i = Vector2i(_viewport_size.x - window.get_size_with_decorations().x, 50)

# TODO: Disable in release mode

var is_global_debug_enabled: bool = false
var _viewport_size: Vector2i = Vector2.ZERO
var _debug_fly_cam_3d: FlyCamera = null
const DEBUG_BOX_CONTAINER: PackedScene = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/debug_box/debug_box_container.tscn")
const MONITOR: PackedScene = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/monitor/monitor.tscn")

signal global_debug_changed(value: bool)

func _ready() -> void:
	_init_main_debug_window()
	_init_monitor()
	_init_tab_container()
	_init_default_debug_box_functionality()

func register_in_inspector(node: Node, icon: Texture2D = inspector._fallback_icon, register_children: bool = false) -> void:
	if (icon == null): icon = inspector._fallback_icon

	inspector._register_inspector(node, icon, register_children)

func _init_main_debug_window() -> void:
	get_viewport().size_changed.connect(func() -> void:
		_viewport_size = get_viewport().get_window().size
	)

	debug.alignment = FlowContainer.ALIGNMENT_CENTER
	_viewport_size = get_viewport().get_window().size

func _init_monitor() -> void:
	monitor.add_child(MONITOR.instantiate())

func _init_tab_container() -> void:
	tab_container.tab_alignment = TabBar.ALIGNMENT_CENTER
	tab_container.tabs_position = TabContainer.POSITION_BOTTOM
	tab_container.clip_tabs = false
	tab_container.set_tab_icon_max_width(0, 32)
	tab_container.set_tab_icon_max_width(1, 32)
	tab_container.set_tab_icon_max_width(2, 32)
	tab_container.set_tab_icon(0, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_fp_camera_component_3d.svg"))
	tab_container.set_tab_icon(1, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_inspector_register.svg"))
	tab_container.set_tab_icon(2, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_movement_component_3d.svg"))

func _physics_process(delta: float) -> void:
	var window_pos: Vector2i = window.get_position_with_decorations()

	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	or (window_pos.x >= 0 and window_pos.x < _viewport_size.x
	and window_pos.y >= 0 and window_pos.y < _viewport_size.y)): return

	# Right Side
	if (window_pos.x > _viewport_size.x):
		_target_position.x = _viewport_size.x - window.get_size_with_decorations().x

	# Left Side
	if (window_pos.x < 0):
		_target_position.x = 25

	# Bottom
	if (window_pos.y > _viewport_size.y):
		_target_position.y = _viewport_size.y - window.get_size_with_decorations().y
#
	# Top
	if (window_pos.y < 0):
		_target_position.y = 50

	create_tween().tween_property(window, "position", _target_position, 0.05)

func _init_default_debug_box_functionality() -> void:
	var built_ins_box: DebugBoxContainer = create_debug_box("Built-Ins")
	built_ins_box.add_plus_minus_buton("Time Scale", Engine.time_scale, Engine.set_time_scale)
	built_ins_box.add_button("Switch Render Views", func() -> void:
		var vp: Viewport = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 6
	)
	built_ins_box.add_toggle_button("Toggle Fullscreen", func() -> void:
		if (DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	)
	built_ins_box.add_toggle_button("Toggle Fly Camera (3D)", func() -> void:
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
	).add_shortcut(KEY_V)
	built_ins_box.add_toggle_button("Toggle Debug", func() -> void:
		is_global_debug_enabled = !is_global_debug_enabled
		global_debug_changed.emit(is_global_debug_enabled)
	)
	built_ins_box.add_toggle_button("Pause Game", func() -> void:
		get_tree().paused = !get_tree().paused
	)

func create_debug_box(title: StringName, background_color: Color = Color.GRAY) -> DebugBoxContainer:
	for debug_box: DebugBoxContainer in debug.get_children():
		if (debug_box.label.text == title):
			return debug_box

	var debug_box_container: DebugBoxContainer = DEBUG_BOX_CONTAINER.instantiate()
	debug_box_container.ready.connect(func() -> void:
		debug_box_container.label.text = title

		var style_box: StyleBox = debug_box_container.background.get_theme_stylebox("panel").duplicate()
		style_box.set("bg_color", background_color)
		debug_box_container.background.add_theme_stylebox_override("panel", style_box)
	)

	debug.add_child(debug_box_container)

	return debug_box_container

func _input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if (event.pressed and event.keycode == KEY_F1):
			if (!window.visible):
				window.visible = true

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_window_window_input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if (event.pressed and event.keycode == KEY_F1):
			window.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_window_close_requested() -> void:
	window.visible = false

func _on_window_visibility_changed() -> void:
	if (window == null): return

	if (window.visible):
		window.position = _target_position

	_target_position = window.position

func _on_window_focus_exited() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

extends Control

@export var debug_name: String
@onready var window: Window = $Window
@onready var inspector: Tree = $Window/TabContainer/Inspector
@onready var debug: FlowContainer = $Window/TabContainer/Debug
@onready var monitor: Panel = $Window/TabContainer/Monitor
var _tree_root: TreeItem
var _position
var _debug_fly_cam_3d: FlyCamera = null

const DEBUG_BOX_CONTAINER = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/debug_box_container.tscn")
const MONITOR: PackedScene = preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/monitor.tscn")

func _ready() -> void:
	_position = get_viewport().get_window().size / 2
	_tree_root = inspector.create_item()
	_tree_root.set_selectable(0, false)
	monitor.add_child(MONITOR.instantiate())
	
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

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.is_action_pressed(debug_name)):
		if (!window.visible):
			window.visible = true
			
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func register_section(node: Node, icon: Texture2D = null) -> void:
	var regsitered: TreeItem = inspector.create_item(_tree_root)
	regsitered.set_text(0, "%s:<%s#%d>" % [node.name, node.name, node.get_instance_id()])
	regsitered.set_icon(0, icon)
	regsitered.set_icon_max_width(0, 35)
	regsitered.set_meta("current_node_id", node.get_instance_id())
	
func _on_tree_item_selected() -> void:
	LogIt.info("Tree selected!")
	var current_node = instance_from_id(inspector.get_selected().get_meta("current_node_id"))
	
	for item: Dictionary in current_node.get_property_list():
			if (item["usage"] == 6 or item["usage"] == PROPERTY_USAGE_STORAGE or item["usage"] == 4102 or item["usage"] == 69632 or item["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE):
				var child = inspector.get_selected().create_child()
				var node_value = current_node.get(item["name"])
				
				child.set_selectable(0, false)
				child.set_text(0, item["name"] + " - " + str(node_value))
				child.set_meta("prev_value", "test")
				child.set_meta("current_var", item["name"])
				child.set_meta("prev_value", node_value)
	
func _physics_process(delta: float) -> void:
	if (is_instance_valid(_tree_root)):
		for child: TreeItem in _tree_root.get_children():
			if (child.collapsed): return
			
			var current_node: Node = instance_from_id(child.get_meta("current_node_id"))
			for var_row: TreeItem in child.get_children():
				var node_value = current_node.get(var_row.get_meta("current_var"))
				if (node_value != var_row.get_meta("prev_value")):
					var_row.set_custom_color(0, Color.YELLOW)
				else:
					var_row.set_custom_color(0, Color.GRAY)
				
				var_row.set_text(0, var_row.get_meta("current_var") + " - " + str(node_value))
				var_row.set_meta("prev_value", node_value)
				
func create_debug_box(title: StringName, background_color: Color = Color.GRAY) -> DebugBoxContainer:
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

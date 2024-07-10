@tool
extends EditorPlugin

# Used https://usefulicons.com/ for icons

# Node: R: 224, G: 224, B: 224
# Node2D: R: 141, G: 165, B: 243
# Node3D: R: 252, G: 127, B: 127
# Control: R: 142, G: 239, B: 151

# Custom Icon Colors:
# Trigger: R: 252, G: 191, B: 126

var toolbox_panel: Control = preload("res://addons/jaysreusablecomponentsandthings/editor/toolbox/toolbox.tscn").instantiate()
var _default_keybinds: Array[Dictionary] = [
	{
		action = &"move_forward",
		key = KEY_W
	},
	{
		action = &"move_backward",
		key = KEY_S
	},
	{
		action = &"move_left",
		key = KEY_A
	},
	{
		action = &"move_right",
		key = KEY_D
	},
	{
		action = &"jump",
		key = KEY_SPACE
	},
		{
		action = &"sprint",
		key = KEY_SHIFT
	},
		{
		action = &"crouch",
		key = KEY_CTRL
	},
		{
		action = &"debug",
		key = KEY_F1
	},
		{
		action = &"interact",
		key = KEY_E
	},
		{
		action = &"mouse_primary_fire",
		key = MOUSE_BUTTON_LEFT
	},
		{
		action = &"mouse_alternate_fire",
		key = MOUSE_BUTTON_RIGHT
	},
		{
		action = &"reload",
		key = KEY_R
	}
]

func _enable_plugin() -> void:
	_init_default_keybinds()

func _disable_plugin() -> void:
	_remove_default_keybinds()

func _init_default_keybinds() -> void:
	for keybind: Dictionary in _default_keybinds:
		var key: InputEventWithModifiers
		if (keybind["key"] is Key):
			key = InputEventKey.new()
			key.physical_keycode = keybind["key"]
		elif (keybind["key"] is MouseButton):
			key = InputEventMouseButton.new()
			key.button_index = keybind["key"]

		var input: Dictionary = {
			"deadzone": 0.5,
			"events": [
				key
			]
		}

		ProjectSettings.set_setting('input/%s' % keybind["action"], input)
	ProjectSettings.save()

func _remove_default_keybinds() -> void:
	for keybind: Dictionary in _default_keybinds:
		ProjectSettings.set_setting('input/%s' % keybind["action"], null)
	ProjectSettings.save()

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things [v%s][/b] has loaded [color=green]successfully![/color]" % get_plugin_version())

	# Add autoload singletons
	add_autoload_singleton("DrawIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/draw/drawit.gd")
	add_autoload_singleton("DebugIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/debug/debugit.tscn")
	add_autoload_singleton("RaycastIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/raycast/raycastit.gd")
	add_autoload_singleton("ResonateIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/audio/resonateit.gd")

	# Add Toolbox to bottom panel
	add_control_to_bottom_panel(toolbox_panel, &"Toolbox")

func _exit_tree() -> void:
	# Remove autoload singletons
	remove_autoload_singleton("DrawIt")
	remove_autoload_singleton("DebugIt")
	remove_autoload_singleton("RaycastIt")
	remove_autoload_singleton("ResonateIt")

	# Remove Toolbox from bottom panel
	remove_control_from_bottom_panel(toolbox_panel)

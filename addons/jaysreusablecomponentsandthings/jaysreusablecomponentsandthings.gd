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

func _enable_plugin() -> void:
	_init_default_keybinds()

func _disable_plugin() -> void:
	_remove_default_keybinds()
	_remove_project_settings()

#region Default Keybinds
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

func _init_default_keybinds() -> void:
	for keybind: Dictionary in _default_keybinds:
		var key: InputEventWithModifiers
		if (keybind["action"].left(5) == &"mouse"):
			key = InputEventMouseButton.new()
			key.button_index = keybind["key"]
		elif (keybind["key"] is Key):
			key = InputEventKey.new()
			key.physical_keycode = keybind["key"]

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
#endregion

#region Project Settings
static var _setting_enabled_color: StringName = "jays_reusable_components/default_colors/enabled"
static var _setting_disabled_color: StringName = "jays_reusable_components/default_colors/disabled"
static var _setting_highlight_color: StringName = "jays_reusable_components/default_colors/highlight"
static var _setting_module_debugit: StringName = "jays_reusable_components/modules/DebugIt"
static var _setting_module_drawit: StringName = "jays_reusable_components/modules/DrawIt"
static var _setting_module_raycastit: StringName = "jays_reusable_components/modules/RaycastIt"
static var _setting_module_resonateit: StringName = "jays_reusable_components/modules/ResonateIt"
static var _setting_module_sceneit: StringName = "jays_reusable_components/modules/SceneIt"
static var _setting_module_levelit: StringName = "jays_reusable_components/modules/LevelIt"

func _init_project_settings() -> void:
	# Enabled color setting
	if (!ProjectSettings.has_setting(_setting_enabled_color)):
		ProjectSettings.set_setting(_setting_enabled_color, Color.GREEN)
	ProjectSettings.set_initial_value(_setting_enabled_color, Color.GREEN)
	ProjectSettings.set_as_basic(_setting_enabled_color, true)
	var _enabled_color_property_info: Dictionary = {
		"name": _setting_enabled_color,
		"type": TYPE_COLOR
	}
	ProjectSettings.add_property_info(_enabled_color_property_info)

	# Disabled color setting
	if (!ProjectSettings.has_setting(_setting_disabled_color)):
		ProjectSettings.set_setting(_setting_disabled_color, Color.RED)
	ProjectSettings.set_initial_value(_setting_disabled_color, Color.RED)
	ProjectSettings.set_as_basic(_setting_disabled_color, true)
	var _disabled_color_property_info: Dictionary = {
		"name": _setting_disabled_color,
		"type": TYPE_COLOR
	}
	ProjectSettings.add_property_info(_disabled_color_property_info)

	# Highlight color setting
	if (!ProjectSettings.has_setting(_setting_highlight_color)):
		ProjectSettings.set_setting(_setting_highlight_color, Color.CORAL)
	ProjectSettings.set_initial_value(_setting_highlight_color, Color.CORAL)
	ProjectSettings.set_as_basic(_setting_highlight_color, true)
	var _highlight_color_property_info: Dictionary = {
		"name": _setting_highlight_color,
		"type": TYPE_COLOR
	}
	ProjectSettings.add_property_info(_highlight_color_property_info)

	# Module DebugIt setting
	if (!ProjectSettings.has_setting(_setting_module_debugit)):
		ProjectSettings.set_setting(_setting_module_debugit, true)
	ProjectSettings.set_initial_value(_setting_module_debugit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_debugit, true)
	ProjectSettings.set_as_basic(_setting_module_debugit, true)
	var _module_debugit_property_info: Dictionary = {
		"name": _setting_module_debugit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_debugit_property_info)

	# Module DrawIt setting
	if (!ProjectSettings.has_setting(_setting_module_drawit)):
		ProjectSettings.set_setting(_setting_module_drawit, true)
	ProjectSettings.set_initial_value(_setting_module_drawit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_drawit, true)
	ProjectSettings.set_as_basic(_setting_module_drawit, true)
	var _module_drawit_property_info: Dictionary = {
		"name": _setting_module_drawit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_drawit_property_info)

	# Module RaycastIt setting
	if (!ProjectSettings.has_setting(_setting_module_raycastit)):
		ProjectSettings.set_setting(_setting_module_raycastit, true)
	ProjectSettings.set_initial_value(_setting_module_raycastit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_raycastit, true)
	ProjectSettings.set_as_basic(_setting_module_raycastit, true)
	var _module_raycastit_property_info: Dictionary = {
		"name": _setting_module_raycastit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_raycastit_property_info)

	# Module ResonateIt setting
	if (!ProjectSettings.has_setting(_setting_module_resonateit)):
		ProjectSettings.set_setting(_setting_module_resonateit, true)
	ProjectSettings.set_initial_value(_setting_module_resonateit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_resonateit, true)
	ProjectSettings.set_as_basic(_setting_module_resonateit, true)
	var _module_resonateit_property_info: Dictionary = {
		"name": _setting_module_resonateit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_resonateit_property_info)

	# Module SceneIt setting
	if (!ProjectSettings.has_setting(_setting_module_sceneit)):
		ProjectSettings.set_setting(_setting_module_sceneit, true)
	ProjectSettings.set_initial_value(_setting_module_sceneit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_sceneit, true)
	ProjectSettings.set_as_basic(_setting_module_sceneit, true)
	var _module_sceneit_property_info: Dictionary = {
		"name": _setting_module_sceneit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_sceneit_property_info)

	# Module LevelIt setting
	if (!ProjectSettings.has_setting(_setting_module_levelit)):
		ProjectSettings.set_setting(_setting_module_levelit, true)
	ProjectSettings.set_initial_value(_setting_module_levelit, true)
	ProjectSettings.set_restart_if_changed(_setting_module_levelit, true)
	ProjectSettings.set_as_basic(_setting_module_levelit, true)
	var _module_levelit_property_info: Dictionary = {
		"name": _setting_module_levelit,
		"type": TYPE_BOOL
	}
	ProjectSettings.add_property_info(_module_levelit_property_info)

	ProjectSettings.save()

func _remove_project_settings() -> void:
	# Gets rid of custom project settings

	ProjectSettings.set_setting(_setting_enabled_color, null)
	ProjectSettings.set_setting(_setting_disabled_color, null)
	ProjectSettings.set_setting(_setting_disabled_color, null)
	ProjectSettings.set_setting(_setting_module_debugit, null)
	ProjectSettings.set_setting(_setting_module_drawit, null)
	ProjectSettings.set_setting(_setting_module_raycastit, null)
	ProjectSettings.set_setting(_setting_module_resonateit, null)
	ProjectSettings.set_setting(_setting_module_sceneit, null)
	ProjectSettings.set_setting(_setting_module_levelit, null)
#endregion

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things [v%s][/b] has loaded [color=green]successfully![/color]" % get_plugin_version())

	# Create custom project settings
	_init_project_settings()

	# Add autoload singletons
	if (!ProjectSettings.has_setting("autoload/DebugIt") and ProjectSettings.get_setting(_setting_module_debugit)):
		add_autoload_singleton(&"DebugIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/debug/debugit.tscn")
	if (!ProjectSettings.has_setting("autoload/DrawIt") and ProjectSettings.get_setting(_setting_module_drawit)):
		add_autoload_singleton(&"DrawIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/draw/drawit.gd")
	if (!ProjectSettings.has_setting("autoload/RaycastIt") and ProjectSettings.get_setting(_setting_module_raycastit)):
		add_autoload_singleton(&"RaycastIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/raycast/raycastit.gd")
	if (!ProjectSettings.has_setting("autoload/ResonateIt") and ProjectSettings.get_setting(_setting_module_resonateit)):
		add_autoload_singleton(&"ResonateIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/audio/resonateit.gd")
	if (!ProjectSettings.has_setting("autoload/SceneIt") and ProjectSettings.get_setting(_setting_module_sceneit)):
		add_autoload_singleton(&"SceneIt", "res://addons/jaysreusablecomponentsandthings/common_components/scene/scene_it.gd")
	if (!ProjectSettings.has_setting("autoload/LevelIt") and ProjectSettings.get_setting(_setting_module_levelit)):
		add_autoload_singleton(&"LevelIt", "res://addons/jaysreusablecomponentsandthings/common_components/scene/level/level_it.gd")

	# Add Toolbox to bottom panel
	add_control_to_bottom_panel(toolbox_panel, &"🛠️ Toolbox")

func _exit_tree() -> void:
	# Remove autoload singletons
	if (!ProjectSettings.get_setting(_setting_module_debugit)):
		remove_autoload_singleton(&"DebugIt")
	if (!ProjectSettings.get_setting(_setting_module_drawit)):
		remove_autoload_singleton(&"DrawIt")
	if (!ProjectSettings.get_setting(_setting_module_raycastit)):
		remove_autoload_singleton(&"RaycastIt")
	if (!ProjectSettings.get_setting(_setting_module_levelit)):
		remove_autoload_singleton(&"LevelIt")
	if (!ProjectSettings.get_setting(_setting_module_resonateit)):
		remove_autoload_singleton(&"ResonateIt")
	if (!ProjectSettings.get_setting(_setting_module_sceneit)):
		remove_autoload_singleton(&"SceneIt")

	# Remove Toolbox from bottom panel
	remove_control_from_bottom_panel(toolbox_panel)

@tool
extends EditorPlugin
class_name JPlugin

# Used https://usefulicons.com/ for icons
# Node Color: R: 224, G: 224, B: 224
# Node2D Color: R: 141, G: 165, B: 243
# Node3D Color: R: 252, G: 127, B: 127
# Trigger Color: R: 252, G: 191, B: 126

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things v%s[/b] has been loaded [color=green]successfully![/color]" % get_plugin_version())

	# Add autoload singletons
	add_autoload_singleton("DrawIt", "res://addons/jaysreusablecomponentsandthings/common_components/draw/drawit.gd")
	add_autoload_singleton("DebugIt", "res://addons/jaysreusablecomponentsandthings/common_components/debug/debugit.tscn")
	add_autoload_singleton("RaycastIt", "res://addons/jaysreusablecomponentsandthings/common_components/raycast/raycastit.gd")
	add_autoload_singleton("ResonateIt", "res://addons/jaysreusablecomponentsandthings/common_components/audio/resonateit.gd")
	add_autoload_singleton("SceneIt", "res://addons/jaysreusablecomponentsandthings/common_components/scene/sceneit.gd")

func _exit_tree() -> void:

	# Remove autoload singletons
	remove_autoload_singleton("DrawIt")
	remove_autoload_singleton("DebugIt")
	remove_autoload_singleton("RaycastIt")
	remove_autoload_singleton("ResonateIt")
	remove_autoload_singleton("SceneIt")

	pass

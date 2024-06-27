@tool
extends EditorPlugin
class_name JPlugin

# Used https://usefulicons.com/ for icons

# Node: R: 224, G: 224, B: 224
# Node2D: R: 141, G: 165, B: 243
# Node3D: R: 252, G: 127, B: 127
# Control: R: 142, G: 239, B: 151

# Custom Icon Colors:
# Trigger: R: 252, G: 191, B: 126

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things v%s[/b] has been loaded [color=green]successfully![/color]" % get_plugin_version())

	# Add autoload singletons
	add_autoload_singleton("DrawIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/draw/drawit.gd")
	add_autoload_singleton("DebugIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/debug/debugit.tscn")
	add_autoload_singleton("RaycastIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/raycast/raycastit.gd")
	add_autoload_singleton("ResonateIt", "res://addons/jaysreusablecomponentsandthings/common_components/autoloads/audio/resonateit.gd")

func _exit_tree() -> void:

	# Remove autoload singletons
	remove_autoload_singleton("DrawIt")
	remove_autoload_singleton("DebugIt")
	remove_autoload_singleton("RaycastIt")
	remove_autoload_singleton("ResonateIt")

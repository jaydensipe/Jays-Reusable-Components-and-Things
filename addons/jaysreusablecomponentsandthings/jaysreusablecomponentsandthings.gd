@tool
extends EditorPlugin
class_name JPlugin

# Used https://usefulicons.com/ for icons
# Node Color: R: 224, G: 224, B: 224
# Node3D Color: R: 255, G: 106, B: 106

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things v%s[/b] has been loaded [color=green]successfully![/color]" % get_plugin_version())

	# Add autoload singletons
	add_autoload_singleton("DrawIt", "res://addons/jaysreusablecomponentsandthings/common_components/draw/drawit.gd")
	add_autoload_singleton("DebugIt", "res://addons/jaysreusablecomponentsandthings/common_components/debug/debugit.tscn")
	add_autoload_singleton("RaycastIt3D", "res://addons/jaysreusablecomponentsandthings/common_components/raycast/raycastit_3d.gd")

	pass

func _exit_tree() -> void:

	# Remove autoload singletons
	remove_autoload_singleton("DrawIt")
	remove_autoload_singleton("DebugIt")
	remove_autoload_singleton("RaycastIt3D")

	pass

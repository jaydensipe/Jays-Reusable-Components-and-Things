@tool
extends EditorPlugin
class_name JPlugin

# Used https://usefulicons.com/ for icons
# Node Color: R: 224, G: 224, B: 224
# Node3D Color: R: 255, G: 106, B: 106

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things v%s[/b] has been loaded [color=green]successfully![/color]" % get_plugin_version())

	# Add custom nodes
	add_custom_type("HealthComponent", "Node", preload("res://addons/jaysreusablecomponentsandthings/common_components/health_component.gd"), null)
	add_custom_type("InspectorRegister", "Node", preload("res://addons/jaysreusablecomponentsandthings/common_components/debug/inspector/inspector_register_component.gd"), null)
	add_custom_type("MovementComponent3D", "Node3D", preload("res://addons/jaysreusablecomponentsandthings/3d_components/movement/movement_component_3d.gd"), null)
	add_custom_type("FPCameraComponent3D", "Node3D", preload("res://addons/jaysreusablecomponentsandthings/3d_components/camera/fp_camera_component_3d.gd"), null)
	pass

func _exit_tree() -> void:

	# Remove custom nodes
	remove_custom_type("HealthComponent")
	remove_custom_type("InspectorRegister")
	remove_custom_type("MovementComponent3D")
	remove_custom_type("FPCameraComponent3D")
	pass

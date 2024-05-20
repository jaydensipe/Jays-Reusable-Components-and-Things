@tool
extends EditorPlugin

# Node Color: R: 224, G: 224, B: 224
# Node3D Color: R: 255, G: 106, B: 106

func _enter_tree() -> void:
	print_rich("[b]Jay's Reusable Components and Things v%s[/b] has been loaded [color=green]successfully![/color]" % get_plugin_version())
	
	# Add custom nodes
	add_custom_type("HealthComponent", "Node", preload("res://addons/jaysreusablecomponentsandthings/common_components/health_component.gd"), preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_health_component.svg"))
	add_custom_type("MovementComponent3D", "Node3D", preload("res://addons/jaysreusablecomponentsandthings/3d_components/movement_component_3d.gd"), preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_movement_component_3d.svg"))
	add_custom_type("FPCameraComponent3D", "Node3D", preload("res://addons/jaysreusablecomponentsandthings/3d_components/fp_camera_component_3d.gd"), preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_fp_camera_component_3d.svg"))
	pass

func _exit_tree() -> void:
	
	# Remove custom nodes
	remove_custom_type("HealthComponent")
	remove_custom_type("MovementComponent3D")
	remove_custom_type("FPCameraComponent3D")
	pass

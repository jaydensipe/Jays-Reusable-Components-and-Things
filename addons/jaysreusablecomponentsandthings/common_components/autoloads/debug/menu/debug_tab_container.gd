extends TabContainer


func _ready() -> void:
	tab_alignment = TabBar.ALIGNMENT_CENTER
	tabs_position = TabContainer.POSITION_BOTTOM
	clip_tabs = false
	set_tab_icon_max_width(0, 32)
	set_tab_icon_max_width(1, 32)
	set_tab_icon_max_width(2, 32)
	set_tab_icon(0, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_fp_camera_component_3d.svg"))
	set_tab_icon(1, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_inspector_register.svg"))
	set_tab_icon(2, preload("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_movement_component_3d.svg"))

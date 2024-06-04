@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_inspector_register.svg")
extends Node
class_name InspectorRegister

@export_group("Config")
@export var class_icon: Texture2D = null
@export_flags("Export Variables", "Script Variables", "Enums", "Add more?") var show_properties: = 0x7

func _ready() -> void:
	DebugIt.register_in_inspector(get_parent(), class_icon, true)

@icon("res://addons/jaysreusablecomponentsandthings/assets/icons/icon_inspector_register.svg")
extends Node

@export var class_icon: Texture2D = null

func _ready() -> void:
	DebugIt.register_in_inspector(get_parent(), class_icon)

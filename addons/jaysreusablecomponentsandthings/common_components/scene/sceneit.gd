extends Node

const LOAD_SCREEN_SCENE = preload("res://addons/jaysreusablecomponentsandthings/2d_components/ui/menus/load_screen_scene.tscn")

var load_progress: Array[int] = []
var _scene_path: String = ""

signal scene_loaded

func load_packed_scene(packed_scene: PackedScene) -> Resource:
	var load_scene: Control = LOAD_SCREEN_SCENE.instantiate()
	get_tree().root.add_child(load_scene)

	_scene_path = packed_scene.resource_path
	ResourceLoader.load_threaded_request(_scene_path)

	await get_tree().create_timer(5.0).timeout

	get_tree().root.remove_child(load_scene)
	return ResourceLoader.load_threaded_get(_scene_path)


func _process(delta: float) -> void:
	var scene_load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(_scene_path, load_progress)
	if (scene_load_status == ResourceLoader.THREAD_LOAD_LOADED):
		scene_loaded.emit()

extends SpawnComponent3D
class_name SceneSpawnComponent3D

# Logic used from https://github.com/uheartbeast/Galaxy-Defiance. Thank you!

@export var scene: PackedScene

func spawn_at_location(spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene) -> Node3D:
	assert(scene is PackedScene, "Ensure a Scene export is set on this Spawn Component.")

	await _check_spawn_delay()

	var instance: Node3D = scene.instantiate()
	parent.add_child(instance)
	instance.position = spawn_position
	instance = _check_randomize_position(instance)

	_check_delete_timer(instance)

	return instance

func spawn_at_location_with_transform(spawn_transform: Transform3D = global_transform, parent: Node = get_tree().current_scene) -> Node3D:
	assert(scene is PackedScene, "Ensure a Scene export is set on this Spawn Component.")

	await _check_spawn_delay()

	var instance: Node3D = scene.instantiate()
	parent.add_child(instance)
	instance.transform = spawn_transform
	instance = _check_randomize_position(instance)

	_check_delete_timer(instance)

	return instance

func spawn_at_location_with_normal(normal: Vector3, spawn_position: Vector3 = global_position, parent: Node = get_tree().current_scene) -> Node3D:
	assert(scene is PackedScene, "Ensure a Scene export is set on this Spawn Component.")

	await _check_spawn_delay()

	var instance: Node3D = scene.instantiate()
	parent.add_child(instance)
	instance.position = spawn_position

	# Ensure instance uses normal from spawn position
	instance.look_at(spawn_position + normal)
	if (normal != Vector3.UP and normal != Vector3.DOWN):
		instance.rotate_object_local(Vector3.RIGHT, 90)

	_check_delete_timer(instance)

	return instance

func _check_delete_timer(instance: Node3D) -> void:
	if (delete_timer):
		get_tree().create_timer(delete_time).timeout.connect(func(): instance.queue_free())

func _check_spawn_delay() -> void:
	if (spawn_delay_timer):
		await get_tree().create_timer(spawn_delay_time).timeout

func _check_randomize_position(instance: Node3D) -> Node3D:
	if (randomize_x):
		instance.rotation_degrees = Vector3(randf_range(0, 360), 0.0, 0.0)
	if (randomize_y):
		instance.rotation_degrees = Vector3(0.0, randf_range(0, 360), 0.0)
	if (randomize_z):
		instance.rotation_degrees = Vector3(0.0, 0.0, randf_range(0, 360))

	return instance

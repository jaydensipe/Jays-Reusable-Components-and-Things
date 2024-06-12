extends Node

func ray_from_camera_3d(max_distance: float = INF, camera: Camera3D = get_viewport().get_camera_3d(), show_debug: bool = false, show_debug_log: bool = false) -> Dictionary:
	var world: World3D = camera.get_world_3d()
	var ray_origin: Vector3 = camera.project_ray_origin(get_viewport().get_window().size / 2)
	var ray_dir: Vector3 = camera.project_ray_normal(get_viewport().get_window().size / 2) * max_distance
	var ray_end: Vector3 = ray_origin + ray_dir
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var result = world.direct_space_state.intersect_ray(query)
	if (show_debug):
		if (result.is_empty()):
			DrawIt.draw_ray_3d(ray_origin, ray_dir, Color.GREEN, 1.5)
		else:
			DrawIt.draw_ray_3d(ray_origin, ray_dir, Color.RED, 1.5)
			DrawIt.draw_wireframe_sphere_3d(result["position"], 0.25, 1.5)
	if (show_debug_log):
		LogIt.debug(result)

	return result

func ray_3d(from: Vector3, destination: Vector3, max_distance: float = INF, show_debug: bool = false, show_debug_log: bool = false) -> Dictionary:
	var world: World3D = get_viewport().get_camera_3d().get_world_3d()
	var ray_origin: Vector3 = from
	var ray_end: Vector3 = from + (destination * max_distance)
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var result = world.direct_space_state.intersect_ray(query)
	if (show_debug):
		if (result.is_empty()):
			DrawIt.draw_ray_3d(ray_origin, destination * max_distance, Color.GREEN, 1.5)
		else:
			DrawIt.draw_ray_3d(ray_origin, destination * max_distance, Color.RED, 1.5)
			DrawIt.draw_wireframe_sphere_3d(result["position"], 0.25, 1.5)
	if (show_debug_log):
		LogIt.debug(result)

	return result

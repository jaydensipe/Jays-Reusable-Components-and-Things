extends Node3D

func ray_from_camera_3d(max_distance: float = INF, show_debug: bool = false, camera: Camera3D = get_viewport().get_camera_3d()) -> Dictionary:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_origin: Vector3 = camera.project_ray_origin(get_viewport().get_window().size / 2)
	var ray_dir: Vector3 = camera.project_ray_normal(get_viewport().get_window().size / 2) * max_distance
	var ray_end: Vector3 = ray_origin + ray_dir
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if (show_debug):
		DrawIt.draw_ray(ray_origin, ray_dir, Color.RED, 1.5)
		LogIt.debug(result)
		if (!result.is_empty()):
			DrawIt.draw_sphere(result["position"], 0.25, Color.LIGHT_CORAL, 1.5)

	return result

func ray_3d(from: Vector3, direction: Vector3, max_distance: float = INF, show_debug: bool = false) -> Dictionary:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_origin: Vector3 = from
	var ray_end: Vector3 = from + direction * max_distance
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if (show_debug):
		DrawIt.draw_ray(ray_origin, direction * max_distance, Color.RED, 1.5)
		LogIt.debug(result)
		if (!result.is_empty()):
			DrawIt.draw_sphere(result["position"], 0.25, Color.LIGHT_CORAL, 1.5)

	return result

extends Node

# Code based on https://github.com/Ryan-Mirch/Line-and-Sphere-Drawing/blob/main/Draw3D.gd. Thank you!
# TODO: Wireframe?

func _input(event):
	# TODO: Implement GUI for all of these, shit is cool
	if event is InputEventKey and Input.is_key_pressed(KEY_P):
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 26

func draw_line(from: Vector3, to: Vector3, color: Color = Color.RED, seconds_to_persist: float = 0.0):
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	var material: ORMMaterial3D = ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(from)
	immediate_mesh.surface_add_vertex(to)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await cleanup(mesh_instance, seconds_to_persist)
	
func draw_ray(origin: Vector3, direction: Vector3, color: Color = Color.RED, seconds_to_persist: float = 0.0):
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var immediate_mesh: ImmediateMesh = ImmediateMesh.new()
	var material: ORMMaterial3D = ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(origin)
	immediate_mesh.surface_add_vertex(origin + direction)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await cleanup(mesh_instance, seconds_to_persist)

func draw_sphere(position: Vector3, radius: float = 0.05, color: Color = Color.RED, seconds_to_persist: float = 0.0):
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var sphere_mesh: SphereMesh =  SphereMesh.new()
	var material: ORMMaterial3D = ORMMaterial3D.new()

	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = position

	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	sphere_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await cleanup(mesh_instance, seconds_to_persist)

func draw_cube(position: Vector3, size: Vector3, color: Color = Color.RED, seconds_to_persist: float = 0.0):
	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	var box_mesh: BoxMesh =  BoxMesh.new()
	var material: ORMMaterial3D = ORMMaterial3D.new()

	mesh_instance.mesh = box_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = position

	box_mesh.size = Vector3(size.x, size.y, size.z)
	box_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await cleanup(mesh_instance, seconds_to_persist)

func cleanup(mesh_instance: MeshInstance3D, seconds_to_persist: float):
	get_tree().get_root().add_child(mesh_instance)
	if (seconds_to_persist > 0):
		await get_tree().create_timer(seconds_to_persist).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
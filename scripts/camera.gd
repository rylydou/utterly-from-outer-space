extends Camera3D

func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	#var dir := og.direction_to(Player.current.global_position)
	var dir := Player.current.global_position.direction_to(global_position)
	
	rotation.y = lerp(atan2(dir.x, dir.z), rotation.y, exp(-1*delta))
#	var dist := cam.global_position.distance_to(Player.current.global_position)
#	$WorldEnvironment.camera_attributes.dof_blur_far_distance = dist + 1.
#	$WorldEnvironment.camera_attributes.dof_blur_near_distance = dist - 1.


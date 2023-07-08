extends Node3D

func _process(delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	var dir := global_position.direction_to(Player.current.global_position)
	rotation.y = lerp_angle(atan2(dir.x, dir.z), rotation.y, exp(-1*delta))
	cam.look_at(Player.current.global_position)


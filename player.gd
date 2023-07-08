extends CharacterBody3D

@export var speed := 1.0

var input: Vector2
func _process(delta: float) -> void:
	input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')

func _physics_process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	var cam_right := camera.global_transform.basis.x
	var cam_forward := camera.global_transform.basis.z
	cam_forward = cam_forward.slide(Vector3.UP).normalized()
	var direction := cam_forward * input.y + cam_right * input.x
	$Cow.rotation.y = atan2(direction.x, direction.z)
	velocity = direction*speed
	move_and_slide()

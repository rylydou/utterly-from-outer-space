class_name Player extends RigidBody3D

static var current: Player

@export var speed := 10.
@export var air_speed := 10.
@export var jump_velocity := 10.

@export var turn_node: Node3D
@export var animation_player: AnimationPlayer

func _ready() -> void:
	current = self

var input: Vector2
var input_jump := false
func _process(delta: float) -> void:
	input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')
	input_jump = Input.is_action_just_pressed('jump')

func _physics_process(delta: float) -> void:
	var is_grounded := get_contact_count() > 0
	
	var camera := get_viewport().get_camera_3d()
	var cam_right := camera.global_transform.basis.x
	var cam_forward := camera.global_transform.basis.z
	cam_forward = cam_forward.slide(Vector3.UP).normalized()
	var direction := cam_forward * input.y + cam_right * input.x
	
	if input != Vector2.ZERO:
		var target_rot := atan2(direction.x, direction.z)
		turn_node.rotation.y = lerp_angle(turn_node.rotation.y, target_rot, .1)
	var spd := speed if is_grounded else air_speed
	constant_force = direction*spd*mass
	
	if input_jump and is_grounded:
		input_jump = false
		is_grounded = false
		apply_central_impulse(Vector3(0, jump_velocity*mass, 0))
		animation_player.play('Jump')
	
	if is_grounded:
		if linear_velocity.length_squared() < .1:
			animation_player.play('Idle')
		else:
			animation_player.play('Walk')

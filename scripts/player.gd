class_name Player extends RigidBody3D

static var current: Player

@export var max_hp := 100.
@onready var hp := max_hp
@export var heal_delay := 3.
var heal_timer := 0.
@export var heal_rate := 100.
@export var boots_object : Node3D

@export_group('Movement')
@export var max_speed := 12.
@export var jump_velocity := 10.
var is_jumping := false
@export var boots_jump_velocity := 20
@export var dash_cooldown := 4.
var til_dash: float
@export var dash_velocity := 10
@export var dash_height := 10
@export var dash_len := 1
var dashing_for
@export var can_dash := false
var dashing

@export_group('References')
@export var turn_node: Node3D
@export var animation_player: AnimationPlayer
@export var bubble_area: Area3D


func _ready() -> void:
	current = self
	get_window().grab_focus()
	get_window().always_on_top = true
	til_dash = dash_cooldown
	dashing_for = -1
	dashing = false
	

func take_damage(amount: float) -> void:
	#hp -= amount
	heal_timer = 0
	if hp <= 0:
		get_tree().reload_current_scene()

var input: Vector2
var input_jump := false
var input_dash := false

func _process(delta: float) -> void:
	input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')
	input_jump = Input.is_action_just_pressed('jump')
	input_dash = Input.is_action_just_pressed('dash')
	
	
	if Input.is_action_just_pressed('bubble'):
		print('bubble')
		for body in bubble_area.get_overlapping_bodies():
			print(body)
			if body.has_method('bubble'):
				body.call('bubble')

func _physics_process(delta: float) -> void:
	heal_timer += delta
	if heal_timer > heal_delay:
		hp = move_toward(hp, max_hp, heal_rate*delta)
	
	var ground_test = move_and_collide(Vector3.DOWN*delta, true)
	var is_grounded := ground_test and ground_test.get_normal().y > 0
	if is_grounded and is_jumping:
		is_jumping = false
	
	var linear_speed := Vector2(linear_velocity.x, linear_velocity.z).length()
	
	var camera := get_viewport().get_camera_3d()
	var cam_right := camera.global_transform.basis.x
	var cam_forward := camera.global_transform.basis.z
	cam_forward = cam_forward.slide(Vector3.UP).normalized()
	var direction := cam_forward * input.y + cam_right * input.x
	
	if can_dash:
		til_dash -= delta
	
	if input != Vector2.ZERO:
		var target_rot := atan2(direction.x, direction.z)
		turn_node.rotation.y = lerp_angle(turn_node.rotation.y, target_rot, .1)
	
	
	if dashing:
		dashing_for -= delta
		if dashing_for < 0:
			dashing = false
	else:
		linear_velocity.x = direction.x*max_speed
		linear_velocity.z = direction.z*max_speed
	
	if input_jump and is_grounded:
		input_jump = false
		is_jumping = true
		is_grounded = false
		set_axis_velocity(Vector3(0, jump_velocity, 0))
		animation_player.play('Jump', -1, 1.2)
		print("Jump")
		
	if input_dash and is_grounded:
		if can_dash and til_dash < 0:
			til_dash = dash_cooldown
			input_dash = false
			is_jumping = true
			is_grounded = false
			input_jump = false
			dashing = true
			dashing_for = dash_len
			var hori = Vector3(cos(turn_node.rotation.y), 0, cos(turn_node.rotation.y)).normalized() * dash_velocity
			set_axis_velocity(Vector3(hori.x, dash_height, hori.z))
			animation_player.play('Jump', -1, 1)
	
	if is_grounded:
		if linear_speed < .1:
			animation_player.play('Idle', -1, 1)
		else:
			animation_player.play('Walk', -1, 2)

func boots():
	jump_velocity = boots_jump_velocity
	print("boots")
	#boots_object.visible = true
	
func dash():
	can_dash = true
	til_dash = 0

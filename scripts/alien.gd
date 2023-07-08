extends StaticBody3D

@export var grace_time := .5
var grace_timer := 0.
@export var shoot_time := .5
var shoot_timer := 0.

@export var look_node: Node3D
@export var turn_node: Node3D
@export var animation_player: AnimationPlayer
@export var raycast: RayCast3D
@export var skeleton: Skeleton3D

var seen_player: Player
var is_bubbled := false
var bubble_timer := 0.

func bubble() -> void:
	is_bubbled = true
	$Bubble.show()

func _physics_process(delta: float) -> void:
	if is_bubbled:
		bubble_timer += delta
		turn_node.visible = int(bubble_timer*20)%2 == 0
		translate(Vector3.UP*delta*bubble_timer*5)
		if bubble_timer > 1.:
			queue_free()
		return
	
	if is_instance_valid(seen_player):
		animation_player.play('AlienArmature|Alien_Idle', .33, 1.)
		var dir := global_position.direction_to(seen_player.global_position)
		turn_node.rotation.y = atan2(dir.x, dir.z)
		look_node.look_at(seen_player.global_position, Vector3.UP, true)
		
		if raycast.get_collider() is Player:
			animation_player.play('AlienArmature|Alien_Punch', .33, 1.)
			
			if grace_timer > grace_time:
				shoot_timer += delta
				if shoot_timer > shoot_time:
					seen_player.take_damage(40.)
					shoot_timer = 0
			grace_timer += delta
	else:
		grace_timer = 0
		shoot_timer = 0
		look_node.rotation = Vector3.ZERO
		turn_node.rotation.y = 0
		animation_player.play('AlienArmature|Alien_Idle', 1., 1.)

func _on_vision_cone_body_entered(body: Node3D) -> void:
	var player = body as Player
	if not player: return
	seen_player = player

func _on_vision_cone_body_exited(body: Node3D) -> void:
	var player = body as Player
	if not player: return
	seen_player = null

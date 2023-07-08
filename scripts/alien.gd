extends Node3D

@export var grace_time := 1.
var grace_timer := 0.

@export var look_node: Node3D

var seen_player: Player

func _physics_process(delta: float) -> void:
	if is_instance_valid(seen_player):
		if abs(look_node.rotation_degrees.y) > 70:
			seen_player = null
			grace_timer = 0
			return
		look_node.look_at(seen_player.global_position, Vector3.UP, true)
		if grace_timer > grace_time:
			get_tree().reload_current_scene()
		grace_timer += delta
	else:
		look_node.rotation = Vector3.ZERO

func _on_vision_cone_body_entered(body: Node3D) -> void:
	var player = body as Player
	if not player: return
	seen_player = player

func _on_vision_cone_body_exited(body: Node3D) -> void:
	var player = body as Player
	if not player: return
	seen_player = null

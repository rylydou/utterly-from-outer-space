extends Node3D

@export var animation_player: AnimationPlayer
var ispressed := false
signal pressed

func _on_area_3d_body_entered(body):
	if not ispressed:
		animation_player.play("pushed")
		pressed.emit()
	ispressed = true
	

extends Node3D

@export var animation_player: AnimationPlayer
signal pressed
signal unpressed
var num_of_bodies := 0

func _on_area_3d_body_entered(body):
	SoundBank.play('scratch', global_position)
	if num_of_bodies == 0:
		animation_player.play("pushed")
		pressed.emit()
	num_of_bodies += 1

func _on_area_3d_body_exited(body):
	SoundBank.play('scratch', global_position)
	num_of_bodies -= 1	
	if num_of_bodies == 0:
		animation_player.play_backwards("pushed")
		unpressed.emit()

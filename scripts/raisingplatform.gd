extends Node3D

@export var animation_player: AnimationPlayer
@export var maxh: float

func raise():
	animation_player.play("raise")

func lower():
	animation_player.play_backwards("raise")


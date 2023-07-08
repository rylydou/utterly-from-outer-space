extends Control

func _process(delta: float) -> void:
	$ColorRect.modulate.a = 1. - Player.current.hp/Player.current.max_hp

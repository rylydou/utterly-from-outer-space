extends Control

func _process(delta: float) -> void:
	$ColorRect.modulate.a = 1. - Player.current.hp/Player.current.max_hp

var showing := false
func get_item(index: int):
	get_tree().paused = true
	%Pan.show()
	for child in %Texts.get_children():
		child.hide()
	%Texts.get_child(index).show()
	await get_tree().create_timer(1., true, false, true)
	showing = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('jump'):
		showing = false
		get_tree().paused = false
		%Pan.hide()

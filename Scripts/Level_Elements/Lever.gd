extends Activable

func _input(event) -> void:
	if event.is_action_pressed("interact"):
		if player_in_area: activated.emit(self)

func _on_lever_activated(_emitter) -> void:
	match get_node("Sprite2D").frame:
		0: get_node("Sprite2D").frame = 1
		1: get_node("Sprite2D").frame = 0
	Funcs.sound_play("res://Sounds/uiclick.mp3", 10, 1)

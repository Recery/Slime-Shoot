extends Activable

func _input(event):
	if event.is_action_pressed("interact") && player_in_area:
		Funcs.sound_play("res://Sounds/Crunch.mp3", 20, 1.25)
		Funcs.particles(Vector2(1.3,1.3), global_position, Color.html("#ffd860"))
		
		player.life += player.max_life * 0.25
		player.energy += player.max_energy * 0.25
		
		queue_free()

extends Player

func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

@onready var fart_cooldown := get_node("Fart_Cooldown")
func _on_extra_physics_process():
	if perk_activated:
		if reduce_energy(1, 0.5):
			if fart_cooldown.is_stopped():
				fart_cooldown.start()
			
			if int(energy) % 3 == 0:
				var particle_size = Vector2(2.2-fart_cooldown.time_left, 2.2-fart_cooldown.time_left)
				Funcs.particles(particle_size, global_position, Color.WEB_GREEN)
		else:
			perk_activated = false
	else:
		fart_cooldown.stop()

var fart_attack := preload("res://Scenes/Player/Poo_Slime/fart_damage.tscn")
func _on_fart_cooldown_timeout():
	var fart_attack_instance := fart_attack.instantiate()
	
	if Funcs.add_to_bullets(fart_attack_instance):
		fart_attack_instance.global_position = global_position
		fart_attack_instance.attack_effects()
		Funcs.sound_play("res://Sounds/FartSound.mp3", 12, 0.9)
	else:
		fart_attack_instance.queue_free()

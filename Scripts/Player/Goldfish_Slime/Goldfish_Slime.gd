extends Player

var create_particles := true

func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

var current_debuff : Buff_Speed_Player
func _on_extra_physics_process():
	if perk_activated: # Tecla apretada
		if reduce_energy(1):
			if current_debuff == null:
				current_debuff = get_speed_debuff()
				add_child(current_debuff)
				resistance += 3
			if create_particles:
				Funcs.particles(Vector2(1.4,1.4), global_position, Color.RED)
				if life + 2 < max_life: life += 2
				else: life = max_life
				create_particles = false
		else:
			perk_activated = false
	else: # Tecla no apretada
		if current_debuff != null:
			current_debuff.free_buff()
			resistance -= 3

func _on_particles_timer_timeout():
	create_particles = true

func get_speed_debuff() -> Buff_Speed_Player:
	var debuff := Buff_Speed_Player.new()
	debuff.weight_to_modify = 0.8
	debuff.duration = 0
	return debuff

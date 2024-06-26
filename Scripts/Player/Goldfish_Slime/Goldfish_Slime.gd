extends Player

@onready var effects_added = false
@onready var create_particles = true

func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

func _on_extra_physics_process():
	if perk_activated: # Tecla apretada
		if reduce_energy(1):
			if not effects_added:
				speed /= 1.2
				resistance += 3
				effects_added = true
			if create_particles:
				Funcs.particles(Vector2(1.4,1.4), global_position, Color.RED)
				if life + 2 < max_life: life += 2
				else: life = max_life
				create_particles = false
		else:
			perk_activated = false
	else: # Tecla no apretada
		if effects_added:
			speed *= 1.2
			resistance -= 3
			effects_added = false

func _on_particles_timer_timeout():
	create_particles = true

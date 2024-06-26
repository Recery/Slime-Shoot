extends Player

@onready var upgraded_speed = false
@onready var create_particles = true

func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

func _on_extra_physics_process():
	if perk_activated: # Tecla apretada
		if reduce_energy(1):
			if not upgraded_speed:
				speed *= 1.5
				upgraded_speed = true
			if create_particles:
				Funcs.dash_smoke(1, 1, global_position)
				create_particles = false
		else:
			perk_activated = false
	else: # Tecla no apretada
		if upgraded_speed:
			speed /= 1.5
			upgraded_speed = false

func _on_particles_timer_timeout():
	create_particles = true

extends Player

@onready var upgraded_speed = false
@onready var create_particles = true

var current_buff : Buff_Speed_Player
func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

func _on_extra_physics_process():
	if perk_activated: # Tecla apretada
		if reduce_energy(1):
			if current_buff == null:
				current_buff = get_speed_buff()
				add_child(current_buff)
			if create_particles:
				Funcs.smoke_effect(Vector2.ONE, global_position)
				create_particles = false
		else:
			perk_activated = false
	else: # Tecla no apretada
		if current_buff != null:
			current_buff.free_buff()

func _on_particles_timer_timeout():
	create_particles = true

func get_speed_buff() -> Buff_Speed_Player:
	var buff := Buff_Speed_Player.new()
	buff.duration = 0
	buff.weight_to_modify = 1.5
	return buff

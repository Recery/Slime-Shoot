extends Ability

func _ready():
	set_process(false)

func _process(_delta):
	player.energy = player.max_energy
	player.can_use_energy = true

func _on_activate():
	get_node("Duration_Timer").start()
	get_node("Particles_Timer").start()
	set_process(true)
	get_node("Use_Sound").play()

func _on_duration_timer_timeout():
	get_node("Particles_Timer").stop()
	set_process(false)

func _on_particles_timer_timeout():
	Funcs.particles(Vector2(1.3,1.3), player.global_position, Color(1, 0.631, 0.373), player)
	Funcs.particles(Vector2(1.3,1.3), Vector2(player.global_position.x + 7, player.global_position.y), Color(1, 0.631, 0.373), player)
	Funcs.particles(Vector2(1.3,1.3), Vector2(player.global_position.x - 7, player.global_position.y), Color(1, 0.631, 0.373), player)

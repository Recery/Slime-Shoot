extends Ability

@onready var particle_timer = get_node("Particle_Timer")
@onready var use_sound = get_node("Use_Sound")

func _on_activate() -> void:
	use_sound.play()
	particle_timer.start()
	player.add_child(get_damage_buff())

func get_damage_buff() -> Buff_Damage_Player:
	var buff := Buff_Damage_Player.new()
	buff.duration = 7
	buff.amount_to_add = 1
	buff.name = "Extra_Damage_Ability_Buff"
	buff.tree_exiting.connect(particle_timer.stop)
	return buff

func _on_particle_timer_timeout() -> void:
	Funcs.particles(Vector2(2.2,2.2), player.global_position, Color(0.4, 0.4, 0.4), player)

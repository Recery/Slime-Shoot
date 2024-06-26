extends Ability

var weapon_cooldowns
var weapons

var times_activated

func _ready(): 
	if not player.is_node_ready():
		await player.ready
	
	weapon_cooldowns = player.get_node("Weapon_Module").cooldowns
	weapons = player.get_node("Weapon_Module").weapons
	
	times_activated = 0

func can_be_activated() -> bool:
	if times_activated < 3:
		return player.reduce_energy(energy_use, energy_recover_time)
	else: return false

func _on_activate():
	if not get_tree().node_added.is_connected(node_added):
		get_tree().node_added.connect(node_added)
	
	times_activated += 1
	
	get_node("Particles_Timer").start()
	get_node("Use_Sound").play()
	
	for _cooldown in weapon_cooldowns:
		_cooldown.wait_time /= 2
	
	for weapon in weapons:
		if "energy_use" in weapon:
			weapon.energy_use /= 2
	
	var rage_instance = load("res://Scenes/Abilities/rage_effect.tscn").instantiate()
	player.add_child(rage_instance)
	rage_instance.global_position = Vector2(player.global_position.x - 5, player.global_position.y - 2)

func node_added(node):
	# Cada vez que se añade un nodo a la escena, se verifica si es un arma del jugador
	# Si lo es, empieza a consumir el tiempo de la habilidad
	if node.is_in_group("Friendly_Damage"):
		if not node.is_node_ready(): await node.ready
		if node.generated_by != 0: return
		get_node("Duration_Timer").start()
		get_tree().node_added.disconnect(node_added)

func _on_duration_timer_timeout():
	get_node("Duration_Timer").stop()
	get_node("Particles_Timer").stop()
	
	for i in range(times_activated):
		for _cooldown in weapon_cooldowns:
			_cooldown.wait_time *= 2
		
		for weapon in weapons:
			if "energy_use" in weapon:
				weapon.energy_use *= 2
	
	times_activated = 0
	
	for child in player.get_children():
		if child.is_in_group("Rage_Effect"): child.queue_free()

func _on_particles_timer_timeout():
	Funcs.particles(Vector2(1.5,1.5), Vector2(player.global_position.x, player.global_position.y), Color(1, 0.337, 0.271), player)

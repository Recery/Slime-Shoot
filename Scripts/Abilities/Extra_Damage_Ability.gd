extends Ability

var weapons_affected : Array = []

@onready var duration_timer = get_node("Duration_Timer")
@onready var particle_timer = get_node("Particle_Timer")
@onready var use_sound = get_node("Use_Sound")

func get_damage_node() -> Damage_Request:
	var dmg_rqst := Damage_Request.new()
	dmg_rqst.damage_to_add = 1
	dmg_rqst.name = "Extra_Damage_Request"
	return dmg_rqst

func add_damage(weapon) -> void:
	if not weapon.is_in_group("Friendly_Damage"): return
	if "damage" not in weapon: return
	if weapon.original_damage == 0: return
	if weapons_affected.has(weapon): return
	
	if not weapon.is_node_ready(): await weapon.ready # Si no está ready, puede causar problemas al ajustar el daño
	weapons_affected.append(weapon)
	if weapon is Friendly_Projectile:
		if not weapon.has_node("Extra_Damage_Request"):
			weapon.add_child(get_damage_node()) # Solo añadir el nodo si es Friendly_Projectile, sino seria incompatible
	else: weapon.damage += 1 # Si no es Friendly_Projectile, se le añade 1 de daño directamente
	
	if duration_timer.time_left == 0:
		duration_timer.start()

func normal_damage() -> void:
	for weapon in weapons_affected:
		if weapon == null: continue
		
		if weapon is Friendly_Projectile:
			if weapon.has_node("Extra_Damage_Request"): # Podria preguntarse afuera del if Friendly_Projectile
				# pero mejor hacerlo acá adentro para ahorrar recursos al llamarlo menos veces
				weapon.get_node("Extra_Damage_Request").queue_free()
		else: weapon.damage = weapon.original_damage
		
	weapons_affected.resize(0)

func can_be_activated() -> bool:
	if get_tree().node_added.is_connected(add_damage): return false
	return player.reduce_energy(energy_use, energy_recover_time)

func _on_activate() -> void:
	use_sound.play()
	particle_timer.start()
	get_tree().node_added.connect(add_damage)

func _on_duration_timer_timeout() -> void:
	normal_damage()
	particle_timer.stop()
	get_tree().node_added.disconnect(add_damage)

func _on_particle_timer_timeout() -> void:
	Funcs.particles(Vector2(2.2,2.2), player.global_position, Color(0.4, 0.4, 0.4), player)

extends Ability

var weapon_cooldowns
var weapons

var active := false

func _ready(): 
	if not player.is_node_ready():
		await player.ready
	
	weapon_cooldowns = player.get_node("Weapon_Module").cooldowns
	weapons = player.get_node("Weapon_Module").weapons

func can_be_activated() -> bool:
	return player.reduce_energy(energy_use, energy_recover_time) and not active

@onready var duration_timer := get_node("Duration_Timer")
@onready var particles_timer := get_node("Particles_Timer")
@onready var use_sound := get_node("Use_Sound")
var rage := preload("res://Scenes/Abilities/rage_effect.tscn")
func _on_activate():
	active = true
	
	duration_timer.start()
	particles_timer.start()
	use_sound.play()
	
	for _cooldown in weapon_cooldowns:
		_cooldown.wait_time /= 2
	
	for weapon in weapons:
		if "energy_use" in weapon:
			weapon.energy_use /= 2
	
	var rage_instance := rage.instantiate()
	player.add_child(rage_instance)
	rage_instance.global_position = Vector2(player.global_position.x - 5, player.global_position.y - 2)

func _on_duration_timer_timeout():
	active = false
	
	particles_timer.stop()
	use_sound.stop()
	
	for _cooldown in weapon_cooldowns:
		_cooldown.wait_time *= 2
	
	for weapon in weapons:
		if "energy_use" in weapon:
			weapon.energy_use *= 2
	
	for child in player.get_children():
		if child.is_in_group("Rage_Effect"): child.queue_free()

func _on_particles_timer_timeout():
	Funcs.particles(Vector2(1.5,1.5), Vector2(player.global_position.x, player.global_position.y), Color(1, 0.337, 0.271), player)

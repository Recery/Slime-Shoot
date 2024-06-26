extends Node2D

const original_damage = 3
var damage

var player
var generated_by : int

var enemies_to_attack = []

func _ready():
	damage = original_damage
	player = Vars.player
	generated_by = 2
	procced()

func procced():
	await get_tree().create_timer(0.1).timeout
	get_enemies_to_attack()
	attack()

func attack():
	var start_pos
	var end_pos
	for i in range(enemies_to_attack.size()):
		if i != 0: await get_tree().create_timer(0.05).timeout
		
		if enemies_to_attack[i] != null: 
			if i == 0: 
				start_pos = player.global_position
				end_pos = enemies_to_attack[i].global_position
			else: 
				start_pos = end_pos
				end_pos = enemies_to_attack[i].global_position
			
			if i < enemies_to_attack.size() - 1: 
				create_shock_visual(start_pos, end_pos)
			Funcs.dash_smoke(0.7, 0.7, enemies_to_attack[i].global_position, 1, Funcs.get_bullets_node(), true)
			Funcs.deal_damage(enemies_to_attack[i], damage)
	
	await get_tree().create_timer(0.1).timeout
	queue_free()

func get_enemies_to_attack():
	for i in range(8):
		if i == 0: 
			enemies_to_attack.append(scan_nearest_enemy(player))
		elif enemies_to_attack[i-1] != null: 
			enemies_to_attack.append(scan_nearest_enemy(enemies_to_attack[i-1]))
		else: break

func scan_nearest_enemy(object):
	if object == null: return null
	
	var scan_range = 55
	if object == player: scan_range = 80
	
	var total_enemies = get_tree().get_nodes_in_group("Enemies")
	var in_range_enemies = []
	for i in range(total_enemies.size()):
		if object.global_position.distance_to(total_enemies[i].global_position) < scan_range && not enemies_to_attack.has(total_enemies[i]):
			in_range_enemies.append(total_enemies[i])
	
	if in_range_enemies.size() == 0: return null
	
	var nearest_enemy
	for i in range(in_range_enemies.size()):
		if i == 0: nearest_enemy = in_range_enemies[i]
		elif object.global_position.distance_to(in_range_enemies[i].global_position) < object.global_position.distance_to(nearest_enemy.global_position):
			nearest_enemy = in_range_enemies[i]
	
	return nearest_enemy

func create_shock_visual(start_pos, end_pos) -> void:
	var shock_instance = load("res://Scenes/Abilities/shock_sprite.tscn").instantiate()
	shock_instance.scale.y = start_pos.distance_to(end_pos) / shock_instance.texture.get_height()
	shock_instance.rotation = atan2(end_pos.y - start_pos.y, end_pos.x - start_pos.x) - 180
	if not Funcs.add_to_bullets(shock_instance): return
	shock_instance.global_position = (start_pos + end_pos) / 2
	await get_tree().create_timer(0.1).timeout
	shock_instance.queue_free()

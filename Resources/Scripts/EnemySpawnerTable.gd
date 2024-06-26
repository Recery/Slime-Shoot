extends Resource
class_name EnemySpawnerTable

## El primer enemigo siempre va a ser el que sale por defecto 
## si por algun motivo no se elige ningun otro.
## Se puede agregar el mismo enemigo en distintas ocasiones para
## gestionar mejor las probabilidades.
@export var enemies_to_spawn : Array[EnemyToSpawn]
@export var starter_level := 0
## El tiempo base que tarda en spawnear un enemigo. Esto es un promedio,
## en base a este valor se calcula el tiempo de spawn dependiendo del nivel
## de spawner y otros valores.
@export var spawn_time := 15

func choose_enemy(spawner_level : int, spawner_pos : Vector2) -> void:
	var enemies_list := load_probs(spawner_level)
	
	#print("----------------------------------")
	var total_prob := 0.0
	for enemy in enemies_list:
		total_prob += enemy.probability
		#print("Spawner level: ", spawner_level, ", enemy: ", enemy.level_to_spawn, ", prob: ", enemy.probability)
	
	var enemy_to_spawn := EnemyInQueue.new()
	enemy_to_spawn.spawner_level = spawner_level
	enemy_to_spawn.spawn_pos = spawner_pos
	
	for enemy in enemies_list:
		if Funcs.probability(enemy.probability, total_prob):
			enemy_to_spawn.enemy = enemy.enemy
			request_spawn(enemy_to_spawn)
			return
	
	enemy_to_spawn.enemy = enemies_to_spawn[0].enemy
	request_spawn(enemy_to_spawn)

func load_probs(spawner_level : int) -> Array[EnemyToSpawn]:
	var spawneable_enemies : Array[EnemyToSpawn] = []
	
	for enemy in enemies_to_spawn:
		if enemy.level_to_spawn <= spawner_level && (enemy.max_level_to_spawn >= spawner_level or enemy.max_level_to_spawn == 0):
			spawneable_enemies.append(enemy.duplicate())
	
	var factor : float = 8.0 / (spawneable_enemies.size() + 1)
	for i in range(spawneable_enemies.size()):
		spawneable_enemies[i].probability += ((factor * spawner_level)*(i+1))
	
	return spawneable_enemies

func request_spawn(enemy : EnemyInQueue):
	var spawned_enemy = enemy.enemy.instantiate()
	
	if spawned_enemy.is_in_group("Big_Enemies"): 
		Vars.main_scene.get_node("Big_Enemies").add_child(spawned_enemy)
	elif spawned_enemy.is_in_group("Flying_Enemies"):
		Vars.main_scene.get_node("Flying_Enemies").add_child(spawned_enemy)
	else: Vars.main_scene.get_node("Enemies").add_child(spawned_enemy)
	spawned_enemy.global_position = enemy.spawn_pos
	
	spawned_enemy.base_speed = spawned_enemy.original_speed + (enemy.spawner_level * 3)
	if spawned_enemy.base_speed > spawned_enemy.original_speed * 2: 
		spawned_enemy.base_speed = spawned_enemy.original_speed * 2
	spawned_enemy.speed = spawned_enemy.base_speed
	
	spawned_enemy.base_damage = spawned_enemy.original_damage + enemy.spawner_level
	spawned_enemy.damage = spawned_enemy.base_damage
	
	spawned_enemy.base_max_life = spawned_enemy.original_max_life + enemy.spawner_level
	spawned_enemy.max_life = spawned_enemy.base_max_life
	spawned_enemy.fill_life()

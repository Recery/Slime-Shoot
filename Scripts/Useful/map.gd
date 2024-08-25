extends Node2D
class_name Map

var player : Player
# Si es true, el jugador no puede teletransportarse por solicitudes
@export var block_teleport := false

## La tabla de spawn que usa este mapa.
@export var spawn_table : EnemySpawnerTable
## Si este mapa usa el modo oscuro del jugador o no.
@export var dark_mode := false

func _init() -> void:
	player = Vars.slime_equipped.instantiate()
	Vars.player = player
	
	connect("ready", _when_ready)

func _when_ready() -> void:
	Vars.current_spawner_table = spawn_table
	
	get_node("Spawn_Position").add_child(player)
	player.toggle_dark_mode.emit(dark_mode)
	
	if has_node("Summons"):
		get_node("Summons").y_sort_enabled = true
	if has_node("Spawn_Position"):
		get_node("Spawn_Position").y_sort_enabled = true
	
	despawn_timer()
	speed_timer()

func despawn_timer():
	var timer := Timer.new()
	add_child(timer)
	timer.connect("timeout", despawn_enemies)
	timer.start(20)

func speed_timer():
	var timer := Timer.new()
	add_child(timer)
	timer.connect("timeout", add_speed_to_enemies)
	timer.start(30)

func despawn_enemies():
	var enemies_to_delete := get_tree().get_nodes_in_group("Enemies").size() - 50
	
	var selected_enemies : Array = []
	var exceptions : Array = []
	
	var i := 0
	var limit := 0
	while i < enemies_to_delete:
		var enemy = Funcs.scan_farthest_enemy(0, null, player, exceptions)
		if enemy != null:
			if not enemy.is_in_group("Boss") and not enemy.wait_player_mode and not enemy.is_in_group("Cant_Despawn"):
				selected_enemies.append(enemy)
				exceptions.append(enemy)
				i += 1
			else: exceptions.append(enemy)
		
		limit += 1 
		if limit > 250: break
	
	for enemy in selected_enemies:
		Funcs.particles(Vector2(2.5,2.5), enemy.global_position, Color.WHITE_SMOKE)
		enemy.queue_free()

func add_speed_to_enemies():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if "speed" in enemy and "base_speed" in enemy:
			if not enemy.is_in_group("Boss") and not enemy.wait_player_mode:
				enemy.base_speed += 2
				if enemy.speed != 0: enemy.speed += 2

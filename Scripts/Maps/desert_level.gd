extends Map

var sandstorm_active := false

var catacombs_progress_bar : Node
var has_progress_bar := true

func _ready() -> void:
	player.add_score.connect(_on_score_added_sandstorm) # Conecta el add_score para la tormenta de arena
	
	Save_System.load_map_state(self)
	if not has_progress_bar: return # Si no tiene la barra de progreso (se genero la escalera), no hacer todo el procedimiento para eso
	
	# Todo lo de añadir las escaleras a las catacumbas
	player.add_score.connect(_on_score_added_catacombs)
	catacombs_progress_bar = load("res://Scenes/Useful/progress_bar.tscn").instantiate()
	player.add_child(catacombs_progress_bar)
	await catacombs_progress_bar.ready
	catacombs_progress_bar.position = Vector2(-48.5, -53)
	catacombs_progress_bar.max_value = 900
	catacombs_progress_bar.min_value = 0
	catacombs_progress_bar.set_current_value(0)

## Spawneo de ladder para las catacumbas
func _on_score_added_catacombs(amount) -> void:
	if player.score + amount >= 900: # Si tiene 900 puntos o mas, invocar escaleras a las catacumbas
		player.add_score.disconnect(_on_score_added_catacombs)
		has_progress_bar = false
		if catacombs_progress_bar != null: catacombs_progress_bar.queue_free()
		spawn_ladder()
	elif catacombs_progress_bar != null: # Sino, actualizar el valor de la barra
		catacombs_progress_bar.update_value.emit(amount)

func spawn_ladder() -> void:
	var ladder_instance : Activable
	ladder_instance = load("res://Scenes/Level_Elements/ladder.tscn").instantiate()
	ladder_instance.map_to_enter = load("res://Scenes/Maps/catacombs.tscn")
	ladder_instance.up = false
	ladder_instance.activated.connect(_on_ladder_used)
	ladder_instance.global_position = player.global_position
	get_node("Spawners").call_deferred("add_child", ladder_instance)

func _on_ladder_used(_ladder : Activable) -> void:
	Save_System.save_map_state(self)

## Inicio de las tormentas de arena
var sandstorm_timer : Timer
func _on_score_added_sandstorm(amount) -> void:
	if player.score + amount >= 900:
		player.add_score.disconnect(_on_score_added_sandstorm)
		sandstorm_timer = Timer.new()
		sandstorm_timer.wait_time = 5
		sandstorm_timer.timeout.connect(_try_sandstorm)
		add_child(sandstorm_timer)
		sandstorm_timer.start()

func _try_sandstorm() -> void:
	if Funcs.probability(10) and not sandstorm_active:
		sandstorm_active = true
		var duration := randf_range(45.0, 90.0)
		get_tree().create_timer(duration).timeout.connect(_end_sandstorm)
		sandstorm_effects()

var sandstone_golem := preload("res://Scenes/Enemies/SandstoneGolem/sandstone_golem.tscn")
var sandstorm := preload("res://Scenes/Level_Elements/sandstorm.tscn")
func sandstorm_effects():
	# Añadir golem
	var sandstone_golem_spawn := EnemyToSpawn.new()
	sandstone_golem_spawn.enemy = sandstone_golem
	sandstone_golem_spawn.level_to_spawn = 0
	sandstone_golem_spawn.probability = 15
	spawn_table.enemies_to_spawn.append(sandstone_golem_spawn)
	
	# Efectos visuales
	var sandstorm_sprite := sandstorm.instantiate()
	if player.has_node("Dark_Mode_Rect"):
		player.get_node("Dark_Mode_Rect").add_child(sandstorm_sprite)
		player.get_node("Dark_Mode_Rect").modulate = Color(0.89, 0.729, 0.4, 0.3)
		sandstorm_sprite.global_position = player.global_position
		player.toggle_dark_mode.emit(true)
	else: sandstorm_sprite.queue_free()

func _end_sandstorm() -> void:
	spawn_table.enemies_to_spawn.remove_at(spawn_table.enemies_to_spawn.size()-1)
	
	if player.has_node("Dark_Mode_Rect/Sandstorm_Effect"):
		player.get_node("Dark_Mode_Rect/Sandstorm_Effect").queue_free()
	player.toggle_dark_mode.emit(false)
	
	# Se espera un poco para poner en false para evitar que se inicie muy rápido otra tormenta
	await get_tree().create_timer(20).timeout
	sandstorm_active = false

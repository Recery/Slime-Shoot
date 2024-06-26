extends Node2D

var spawner_level := 0
var spawn_cooldown : Timer
var level_loaded_by_state := false

var timer_setted : bool

var spawn_table : EnemySpawnerTable

func _ready():
	if not Vars.main_scene.is_node_ready():
		await Vars.main_scene.ready
	
	spawn_cooldown = get_node("Spawn_Cooldown")
	timer_setted = false
	spawn_table = Vars.current_spawner_table
	
	if not level_loaded_by_state:
		spawner_level = spawn_table.starter_level

@onready var sprite := get_node("Sprite2D")
func _process(_delta) -> void:
	sprite.rotation_degrees += 1
	if !timer_setted:
		sprite.frame = 0
		timer_setted = true
		spawn_cooldown.start(get_wait_time())
	elif spawn_cooldown.time_left < 2:
		sprite.frame = 1

func get_wait_time() -> float:
	var first_value : float = max((spawn_table.spawn_time - 3) - (spawner_level * 0.2), 2)
	var second_value : float = max((spawn_table.spawn_time + 3) - (spawner_level * 0.2), 2)
	return randf_range(first_value, second_value)

func spawn_enemy() -> void:
	spawn_table.choose_enemy(spawner_level, global_position)
	
	spawn_cooldown.start()
	
	if Funcs.probability(35) && spawner_level < 100: 
		spawner_level += 1

func _on_spawn_cooldown_timeout():
	# Min devuelve el menor de los valores que se le manda a la función
	# Cada nivel que suba el spawner aumenta la posibilidad de spawn en 1%, pero el límite es 70%
	var percentage = min(22 + spawner_level, 70)
	
	# Con probability el spawner tiene una cierta
	# probabilidad de spawnear un enemigo en cada intento
	if Funcs.probability(percentage): spawn_enemy()
	
	# Cada vez que se intenta spawnear un enemigo,
	# el temporizador de spawn debe volver a ajustar su tiempo
	# de manera aleatoria, esta variable controla eso
	timer_setted = false

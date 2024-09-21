extends Node2D

var level_loaded_by_state := false

var spawner_level := 0
var spawn_table : EnemySpawnerTable

@onready var spawn_cooldown := get_node("Spawn_Cooldown") as Timer
@onready var sprite := get_node("Sprite2D")

func _ready() -> void:
	if not Vars.main_scene.is_node_ready():
		await Vars.main_scene.ready
	
	spawn_table = Vars.current_spawner_table
	
	if not level_loaded_by_state:
		spawner_level = spawn_table.starter_level
	
	spawn_cooldown.start(get_wait_time())

func _physics_process(_delta : float) -> void:
	sprite.rotation_degrees += 1
	
	if spawn_cooldown.time_left < 2: sprite.frame = 1
	else: sprite.frame = 0

func get_wait_time() -> float:
	var first_value : float = max((spawn_table.spawn_time - 3) - (spawner_level * 0.2), 2)
	var second_value : float = max((spawn_table.spawn_time + 3) - (spawner_level * 0.2), 2)
	return randf_range(first_value, second_value)

func spawn_enemy() -> void:
	spawn_table.choose_enemy(spawner_level, global_position)
	
	if Funcs.probability(35) and spawner_level < 100: 
		spawner_level += 1

func _on_spawn_cooldown_timeout() -> void:
	# Min devuelve el menor de los valores que se le manda a la función
	# Cada nivel que suba el spawner aumenta la posibilidad de spawn en 1%, pero el límite es 70%
	var percentage : int = min(22 + spawner_level, 70)
	
	if Funcs.probability(percentage): spawn_enemy()
	
	spawn_cooldown.start(get_wait_time())

extends Node

signal change_main_scene(scene)

var main_scene : Node
var current_score : int # El puntaje no se reinicia a cero hasta que se entre nuevamente a un mapa desde el menu
var total_points
var player : Player

# Guardado
var save_file : SaveFile

var cinematics_played : Array[int]
var almanac_unlocked : Array[String] # Guarda los paths de las escenas de los enemigos, no la escena directamente

var weapons_equipped := [null, null, null]
var weapons_unlocked := [null]
var abilities_equipped := [null, null, null]
var abilities_unlocked := []
var passives_equipped := [null, null, null]
var passives_unlocked := []
var slime_equipped : PackedScene
var slimes_unlocked = [null]
var hat_equipped : PackedScene
var hats_unlocked := []
var pet_equipped : PackedScene
var pets_unlocked := []
# Fin guardado

var map_state_data : MapStateData
var current_spawner_table : EnemySpawnerTable

var settings_data : SettingsData

signal draw_equipped_slime

# Segun el ultimo mapa que se jugo, muestra una foto de ese mapa en el menu
enum menu_maps {
	GRASSLANDS,
	DESERT,
	SNOW,
	CYBERSPACE
	}
var menu_map_photo := menu_maps.GRASSLANDS

func _init() -> void:
	total_points = 500

func _ready() -> void:
	main_scene = get_tree().root.get_child(4).get_child(0)
	
	change_main_scene.connect(set_main_scene)
	
	current_spawner_table = load("res://Resources/Setted_Resources/SpawnerTables/GrasslandsSpawnTable.tres")

func set_main_scene(scene : Node) -> void:
	main_scene = scene
	
	if not main_scene.is_node_ready(): await main_scene.ready
	for child in Funcs.get_all_children(main_scene):
		if child.name == "Shadow" and not settings_data.shadows:
			if not child.get_parent().is_in_group("Player_Slime"):
				child.queue_free()

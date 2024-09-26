extends Node

signal change_main_scene(scene)

var main_scene : Node
var current_score : int # El puntaje no se reinicia a cero hasta que se entre nuevamente a un mapa desde el menu
var player : Player

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

func _ready() -> void:
	main_scene = get_tree().root.get_child(5).get_child(0)
	
	change_main_scene.connect(set_main_scene)
	
	current_spawner_table = load("res://Resources/Setted_Resources/SpawnerTables/GrasslandsSpawnTable.tres")

func set_main_scene(scene : Node) -> void:
	main_scene = scene
	
	if not main_scene.is_node_ready(): await main_scene.ready
	for child in Funcs.get_all_children(main_scene):
		if child.name == "Shadow" and not SaveSystem.get_curr_file().save_settings.shadows:
			if not child.get_parent().is_in_group("Player_Slime"):
				child.queue_free()

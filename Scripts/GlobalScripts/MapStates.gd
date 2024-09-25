extends Node

# Para guardar el estado de un mapa
func save_map_state(map:Node):
	var map_state_data = MapStateData.new()
	
	for child in Funcs.get_all_children(map):
		if child.is_in_group("Enemy_Spawner"):
			map_state_data.spawners_level.append(child.spawner_level)
	
	map_state_data.has_progress_bar = map.has_progress_bar
	
	Vars.map_state_data = map_state_data

func load_map_state(map:Node):
	var children := Funcs.get_all_children(map)
	for i in range(children.size()):
		if children[i].is_in_group("Enemy_Spawner"):
			children[i].level_loaded_by_state = true
			children[i].spawner_level = Vars.map_state_data.assign_spawner_level(i)
	
	Vars.player.add_score.emit(0, null) # Emitir esta señal unicamente para actualizar la label de puntaje
	
	if "has_progress_bar" in map:
		map.has_progress_bar = Vars.map_state_data.has_progress_bar

func reset_map_state():
	Vars.current_score = 0
	Vars.map_state_data = MapStateData.new()

extends Resource
class_name MapStateData

var spawners_level : Array[int]
var player_score := 0
var has_progress_bar := true

## Si añade o no los puntos guardados al morir. 
# Esto sirve en mapas que depende de otro, si muere en ese mapa "hijo" perderia los puntos del mapa "padre" que está cargado
var add_points_on_death := true

func assign_spawner_level(array_pos:int) -> int:
	if array_pos < spawners_level.size():
		return spawners_level[array_pos]
	
	return 0

extends Resource
class_name MapStateData

var spawners_level : Array[int]
var has_progress_bar := true

## Si añade o no los puntos guardados al morir. 

func assign_spawner_level(array_pos:int) -> int:
	if array_pos < spawners_level.size():
		return spawners_level[array_pos]
	
	return 0

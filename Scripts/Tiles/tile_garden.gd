extends TileMap

func _physics_process(_delta: float) -> void:
	if player_on_bridge():
		tile_set.set_physics_layer_collision_layer(0,0)
	elif tile_set.get_physics_layer_collision_layer(0) == 0:
		tile_set.set_physics_layer_collision_layer(0,1)

func player_on_bridge() -> bool:
	var cell_pos := local_to_map(to_local(Vars.player.global_position))
	var cell := get_cell_source_id(2, cell_pos)
	tile_set.set_physics_layer_collision_layer(0,0)
	return cell != -1

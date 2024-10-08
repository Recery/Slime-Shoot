extends Resource
class_name SummonsModule

var minions : Array[Summon_Minion]
var turrets : Array[Node2D]
var pet : Summon_Minion

func add_minion(minion : Summon_Minion) -> void:
	if minion.is_in_group("Pet"): pet = minion
	else: minions.append(minion)

func add_turret(turret : Node2D) -> void:
	turrets.append(turret)
	turret.tree_exited.connect(remove_null_turrets)

func remove_null_turrets() -> void:
	# Cuando se libera una torreta, elimina todas las torretas que no existan
	Funcs.remove_array_elements(turrets, null)

func set_idle_positions(source_pos : Vector2) -> void:
	# Eliminar cualquier minion que no exista antes de calcular las idle position
	Funcs.remove_array_elements(minions, null)
	
	const radius := 40
	var circle_points := minions.size()
	for i in range(circle_points):
		var angle := i * (2 * PI / circle_points)
		var idle_pos := find_valid_pos(source_pos, radius, angle)
		
		minions[i].idle_pos = idle_pos

func find_valid_pos(source_pos : Vector2, radius : float, angle : float) -> Vector2:
	var space_state := Vars.player.get_world_2d().direct_space_state
	for i in range(10):
		var x := source_pos.x + radius * cos(angle)
		var y := source_pos.y + radius * sin(angle)
		var new_pos := Vector2(x,y)
		
		var params := PhysicsRayQueryParameters2D.create(Vars.player.global_position, new_pos, 8)
		var result := space_state.intersect_ray(params)
		if not result or not (result.collider is TileMap):
			# Es una posicion valida, devolver esta posicion
			return new_pos
		
		# Posicion invalida, achicar el radio para generar nueva posicion
		radius *= 0.8
	
	# No se encontro ninguna posicion valida, devolver la source_pos (que deberia ser la posicion del jugador)
	return source_pos
	

func teleport_minions_to_player() -> void:
	for minion in minions:
		if minion == null: continue
		minion.global_position = Vars.player.global_position
	
	if pet != null:
		pet.global_position = Vars.player.global_position

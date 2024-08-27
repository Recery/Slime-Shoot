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
		var x := source_pos.x + radius * cos(angle)
		var y := source_pos.y + radius * sin(angle)
		minions[i].idle_pos = Vector2(x,y)

func teleport_minions_to_player() -> void:
	for minion in minions:
		if minion == null: continue
		minion.global_position = Vars.player.global_position
	
	if pet != null:
		pet.global_position = Vars.player.global_position

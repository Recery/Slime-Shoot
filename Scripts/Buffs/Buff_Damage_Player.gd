extends Buff
class_name Buff_Damage_Player

var weight_to_add := 1.0
var amount_to_add := 0.0

func _ready():
	affected_object = get_parent()
	if not affected_object is Player:
		printerr("Error: The affected object of this damage buff is not a player.")
		queue_free()
		return
	
	buff_application(self)

var affected_projs : Array[Node]
func buff_application(buff):
	if buff == self:
		# Conecta para añadir daño a los nuevos proyectiles que entran
		get_tree().node_added.connect(add_damage)
		for proj in get_tree().get_nodes_in_group("Friendly_Damage"):
			# Añade daño a los proyectiles que ya existen
			if proj == null: continue
			add_damage(proj)
	elif buff is Buff_Damage_Player:
		for proj in affected_projs:
			# Vuelve a añadir daño a los proyectiles afectados ya que otro buff reestablecio los efectos
			if proj == null: continue
			if buff.affected_projs.has(proj): add_damage(proj)

func add_damage(proj):
	if not Funcs.is_safe_damage(proj): return
	
	# Esperar a ready para ajustar correctamente el daño
	if not proj.is_node_ready(): await proj.ready
	
	if not affected_projs.has(proj):
		proj.damage += get_damage(proj)
		affected_projs.append(proj)

func get_damage(proj) -> float:
	var total_extra_damage := amount_to_add
	if weight_to_add > 0:
		# Fórmula para añadir daño de modo que al añadirlo al daño del arma sea igual que multiplicarlo por el peso
		total_extra_damage += (proj.original_damage * weight_to_add) - proj.original_damage
	
	return total_extra_damage

func remove_buff():
	get_tree().node_added.disconnect(add_damage)
	for proj in affected_projs:
		if proj == null: continue
		proj.damage = proj.original_damage

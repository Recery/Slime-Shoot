extends Node2D

func _ready():
	get_tree().node_added.connect(critical_damage)

func get_damage_node() -> Damage_Request:
	var dmg_rqst := Damage_Request.new()
	dmg_rqst.weight_to_add = 2
	dmg_rqst.name = "Critical_Damage_Request"
	return dmg_rqst

func critical_damage(proj) -> void: # Persistentes: Cuando "nace" el proyectil
	# Un choclo de verificaciones para evitar errores
	if proj == null: return
	if not proj.is_in_group("Friendly_Damage"): return
	if proj.has_node("Critical_Damage_Request"): return # proj ya tiene el daño duplicado, no hacer nada
	if "damage" not in proj: return
	if not Funcs.probability(10): return
	
	if not proj.is_node_ready(): await proj.ready
	if proj is Friendly_Projectile:
		if proj.persistent and not proj.reset_persistent.is_connected(reset_persistent_projs):
			# Conecta señal para que sea reiniciado el daño de proj eliminando el Damage_Request
			proj.reset_persistent.connect(reset_persistent_projs)
		proj.add_child(get_damage_node())
	else: proj.damage *= 2

# Nótese que no hace falta eliminar el nodo Critical_Damage_Request
# ya que en general los proyectiles van a morir y por lo tanto tambien muere ese nodo
# Únicamente es eliminan en el caso de los persistentes ya que son proyectiles que nunca mueren

func reset_persistent_projs(proj) -> void: # Persistentes: Cuando "muere" el proyectil
	if proj == null: return
	
	if proj.has_node("Critical_Damage_Request"):
		proj.get_node("Critical_Damage_Request").queue_free()
	
	proj.reset_persistent.disconnect(reset_persistent_projs)

extends Node2D
class_name Damage_Request

# Request de daño para manejar correctamente el daño de proyectiles
# Fundamental en proyectiles persistentes

@onready var proj : Friendly_Projectile = get_parent()

var damage_to_add := 0.0 # Se usa para añadir una cantidad de daño en especifico (+1, por ejemplo)
var weight_to_add := 0.0 # Se usa para añadir daño por un peso definido multiplicado por original_damage (x2 de daño, por ejemplo)

var total_extra_damage := 0.0 # Para guardar el total de daño extra que se modifico del arma, para evitar andar haciendo divisiones raras

func _ready():
	proj.child_exiting_tree.connect(_on_proj_child_exiting_tree)
	tree_exiting.connect(_on_queue_free)
	
	total_extra_damage += damage_to_add
	if weight_to_add > 0: # Si se multiplica por cero puede generar resultados no deseados en total_extra_damage al usar damage_to_add
		# Fórmula para añadir daño de modo que al añadirlo al daño del arma sea igual que multiplicarlo por el peso
		total_extra_damage += (proj.original_damage * weight_to_add) - proj.original_damage
	
	proj.damage += total_extra_damage

func _on_proj_child_exiting_tree(child):
	if not child is Damage_Request or child == null or child == self: return
	
	# Se añade el daño total de nuevo ya que al liberarse otro nodo del mismo tipo
	# el daño se reinicio por completo como se ve en _on_queue_free()
	# Todos los nodos de este tipo adjuntos al proyectil vuelven
	# a sumar el daño y queda como antes pero sin el daño extra del daño liberado
	proj.damage += total_extra_damage

# IMPORTANTE El queue_free generalmente debe ser controlado por el responsable de crear este Damage_Request
func _on_queue_free():
	proj.damage = proj.original_damage

extends Enemy

var shoot_pos := Vector2.ZERO
@onready var sandy_eagle := get_node("Sandy_Eagle")
func _ready():
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").stop()

const min_distance = 50 # La distancia minima a la que el boss puede estar del jugador (si es menos que esto se aleja del jugador)
const max_distance = 100 # La distancia maxima a la que el boss puede estar del jugador (si es mas que esto se acerca al jugador)
func _physics_process(_delta):
	shoot_pos = Vars.player.global_position
	
	if global_position.distance_to(player.global_position) > max_distance:
		speed = base_speed
	elif global_position.distance_to(player.global_posi10tion) < min_distance:
		speed = -base_speed
	
	Funcs.weapon_rotation(sandy_eagle,Vector2(10,0), self)

func shoot():
	pass

func regen():
	pass

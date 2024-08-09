extends Enemy

var shoot_pos := Vector2.ZERO
@onready var sandy_eagle := get_node("Sandy_Eagle")
@onready var goldfish_trident := get_node("Goldfish_Trident")

@onready var wall_ray := get_node("WallRay")
func _ready():
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").stop()

const min_distance = 50 # La distancia minima a la que el boss puede estar del jugador (si es menos que esto se aleja del jugador)
const max_distance = 100 # La distancia maxima a la que el boss puede estar del jugador (si es mas que esto se acerca al jugador)
func _physics_process(_delta):
	shoot_pos = Vars.player.global_position
	
	
	if not charging:
		if global_position.distance_to(player.global_position) > max_distance:
			speed = base_speed
		elif global_position.distance_to(player.global_position) < min_distance:
			speed = -base_speed
	
	if is_on_wall():
		if not charging: charge()
	
	
	Funcs.weapon_rotation(goldfish_trident,Vector2(10,0), self)

func shoot():
	pass

var charging := false
func charge():
	charging = true
	speed = base_speed
	add_child(get_speed_buff())
	force_pathfinding_update()
	await get_tree().create_timer(0.75).timeout
	charging = false

func get_speed_buff() -> Buff:
	var buff := Buff.new()
	buff.duration = 0.75
	buff.stat_to_modify = "Speed"
	buff.type = "Buff"
	buff.weight_to_modify = 1.75
	buff.name = "Mummified_Dash"
	return buff

func regen():
	pass

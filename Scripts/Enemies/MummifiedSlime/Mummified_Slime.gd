extends Enemy

var shoot_pos := Vector2.ZERO

func _ready():
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").stop()

@onready var sandy_eagle := get_node("Sandy_Eagle")
@onready var move_ray := get_node("Move_Ray")
func _physics_process(_delta):
	shoot_pos = Vars.player.global_position
	
	Funcs.weapon_rotation(sandy_eagle,Vector2(10,0), self)
	
	move_ray.rotation_degrees += 1
	
	if custom_target_pos == null: set_new_pos()
	elif global_position.distance_to(custom_target_pos) < 10: set_new_pos()

func set_new_pos():
	if move_ray.get_collider() == null:
		var new_pos := to_global(move_ray.target_position)
		if new_pos.distance_to(player.global_position) > 100 and new_pos.distance_to(player.global_position) < 200:
			set_custom_target_position(new_pos)
		else:
			reset_custom_target_position()

func shoot():
	pass

func regen():
	pass

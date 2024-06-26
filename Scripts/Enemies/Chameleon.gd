extends Enemy

@onready var chase_timer := get_node("Chase_Timer")
@onready var sprite := get_node("AnimatedSprite2D")

var animation : String
var previous_life

func _ready():
	set_anim_color()
	previous_life = max_life

func set_anim_color() -> void:
	match randi_range(0,2):
		0: animation = "move_red"
		1: animation = "move_blue"
		2: animation = "move_yellow"
	
	sprite.play(animation)

func _physics_process(_delta):
	if chase_timer.is_stopped():
		if global_position.distance_to(player.global_position) > 175:
			chase_player()
		elif global_position.distance_to(player.global_position) > 60:
			stay_invisible()
		else:
			force_pathfinding_update()
			chase_timer.start()
	else:
		chase_player()
	
	if previous_life != life:
		force_pathfinding_update()
		chase_timer.start()
		previous_life = life
	
	sprite.flip_h = player.global_position.x < global_position.x

func chase_player():
	if not is_in_group("Full_Freezed"): moving = true
	sprite.play(animation)
	modulate.a = 1

func stay_invisible():
	moving = false
	sprite.play("invisible")
	modulate.a = 0.2

func _on_die():
	Funcs.regular_explosion(1.2, 1.2, global_position, Funcs.get_bullets_node(), 4, true)

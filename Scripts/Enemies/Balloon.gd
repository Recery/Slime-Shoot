extends Enemy

func _ready():
	match randi_range(0,5):
		0: get_node("AnimationPlayer").current_animation = "blue"
		1: get_node("AnimationPlayer").current_animation = "green"
		2: get_node("AnimationPlayer").current_animation = "red"
		3: get_node("AnimationPlayer").current_animation = "pink"
		4: get_node("AnimationPlayer").current_animation = "gray"
		5: get_node("AnimationPlayer").current_animation = "brown"
	
	life_checking()

func life_checking():
	if not is_node_ready(): await ready
	if base_max_life > 1:
		base_max_life -= 1
	max_life = base_max_life
	life = max_life

func _physics_process(_delta) -> void:
	if velocity.x < 0:
		rotation_degrees = lerp(rotation_degrees, -5.0, 0.1)
	else:
		rotation_degrees = lerp(rotation_degrees, 5.0, 0.1)

func _on_die():
	Funcs.regular_explosion(0.8, 0.8, global_position, Vars.main_scene, 0, false)
	Funcs.sound_play_2d("res://Sounds/Balloon_Pop.mp3", global_position, 9, randf_range(0.85,1.1))

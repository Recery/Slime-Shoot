extends Enemy_Projectile

func _ready():
	if Funcs.probability(50): die.connect(explode)
	else: die.connect(summon_bugs)

func explode():
	damage *= 2
	get_node("CollisionShape2D").scale = Vector2(3,3)
	Funcs.regular_explosion(2.2, 2.2, global_position, Funcs.get_bullets_node(), 6, true)

var moth := preload("res://Scenes/Enemies/slime_eater_moth.tscn")
var scorpion := preload("res://Scenes/Enemies/scorpion.tscn")
func summon_bugs():
	if Funcs.probability(50):
		# Invocar polillas
		var moth_1 : Enemy = moth.instantiate()
		moth_1.wait_player_mode = true
		var moth_2 : Enemy = moth.instantiate()
		moth_2.wait_player_mode = true
		if Vars.main_scene.has_node("Flying_Enemies"):
			Vars.main_scene.get_node("Flying_Enemies").add_child(moth_1)
			moth_1.global_position = global_position
			moth_1.global_position.x -= 10
			moth_1.waiting_player = false
			
			Vars.main_scene.get_node("Flying_Enemies").add_child(moth_2)
			moth_2.global_position = global_position
			moth_2.global_position.x += 10
			moth_2.waiting_player = false
		else:
			moth_1.queue_free()
			moth_2.queue_free()
	else:
		var scorpion_instance : Enemy = scorpion.instantiate()
		scorpion_instance.wait_player_mode = true
		if Vars.main_scene.has_node("Enemies"):
			Vars.main_scene.get_node("Enemies").add_child(scorpion_instance)
			scorpion_instance.global_position = global_position
			scorpion_instance.waiting_player = false
		else: scorpion_instance.queue_free()
	
	Funcs.sound_play("res://Sounds/EggCrack.mp3", 6, 0)
	Funcs.particles(Vector2(2,2.5), global_position, Color.hex(816271))

extends AnimatedSprite2D

func _ready():
	var hatch_timer := Timer.new()
	add_child(hatch_timer)
	hatch_timer.connect("timeout", _on_hatch_timeout)
	hatch_timer.start(5)

func _on_hatch_timeout():
	Funcs.sound_play("res://Sounds/EggCrack.mp3", 4, 0)
	
	var larva_instance : Node = load("res://Scenes/Enemies/slime_eater_larva.tscn").instantiate()
	Vars.main_scene.get_node("Enemies").add_child(larva_instance)
	larva_instance.global_position = global_position
	
	Funcs.particles(Vector2(1,1), global_position, Color.BEIGE)
	queue_free()

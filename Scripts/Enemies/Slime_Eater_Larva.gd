extends Enemy

func _ready():
	max_life = 1
	life = max_life
	
	var growth_timer := Timer.new()
	add_child(growth_timer)
	growth_timer.connect("timeout", _on_growth_timeout)
	growth_timer.start(25)

@onready var sprite := get_node("AnimatedSprite2D")
func _physics_process(_delta):
	sprite.rotation = Funcs.get_angle(player.global_position, sprite.global_position) - 1.5708

func _on_growth_timeout():
	var moth_instance : Node = load("res://Scenes/Enemies/slime_eater_moth.tscn").instantiate()
	Vars.main_scene.get_node("Flying_Enemies").add_child(moth_instance)
	moth_instance.global_position = global_position
	
	Funcs.particles(Vector2(2,1.5), global_position, Color.LIGHT_SALMON)
	queue_free()

func _on_die():
		Funcs.regular_explosion(0.7, 0.7, global_position, Vars.main_scene, 2, true)

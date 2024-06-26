extends Enemy

var lay_egg_timer : Timer
var laying_timer : Timer

func _ready():
	# Crear timers para poner huevos
	lay_egg_timer = Timer.new()
	add_child(lay_egg_timer)
	lay_egg_timer.connect("timeout", _on_lay_timeout)
	lay_egg_timer.one_shot = true
	lay_egg_timer.start(16)
	
	laying_timer = Timer.new()
	add_child(laying_timer)
	laying_timer.one_shot = true
	laying_timer.connect("timeout", _on_laying_timeout)

@onready var sprite := get_node("AnimatedSprite2D")
func _physics_process(_delta):
	sprite.flip_h = player.global_position.x < global_position.x

func _on_lay_timeout():
	if waiting_player: 
		lay_egg_timer.start(16)
		return
	
	moving = false
	laying_timer.start(2)

func _on_laying_timeout():
	var egg_instance : Node2D = load("res://Scenes/Enemies/moth_egg.tscn").instantiate()
	Vars.main_scene.get_node("Enemies").add_child(egg_instance)
	egg_instance.global_position = global_position
	
	moving = true
	
	lay_egg_timer.queue_free()
	laying_timer.queue_free()

func _on_die():
		Funcs.regular_explosion(0.9, 0.9, global_position, Vars.main_scene, 2, true)

extends Player

func _input(event) -> void:
	if event.is_action_pressed("perk"): # Tecla apretada
		perk_activated = true
	elif event.is_action_released("perk"): # Tecla no apretada
		perk_activated = false

@onready var cooldown_cake := get_node("Cooldown_Cake_Perk")
func _on_extra_physics_process() -> void:
	if perk_activated:
		if cooldown_cake.time_left == 0:
			create_cake()

var cake := preload("res://Scenes/Player/Creamy_Slime/cake_trap.tscn")
func create_cake() -> void:
	if reduce_energy(60, 2.2):
		var cake_instance = cake.instantiate()
		if Funcs.add_to_summons(cake_instance):
			cake_instance.global_position = global_position
			Funcs.particles(Vector2(2, 2), global_position, Color.GHOST_WHITE)
			Funcs.sound_play("res://Sounds/Cake.mp3", 8, 2)
		else: cake_instance.queue_free()
		cooldown_cake.start()

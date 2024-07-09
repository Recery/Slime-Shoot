extends Player

func _input(event) -> void:
	if event.is_action_pressed("perk"): # Tecla apretada
		perk_activated = true
	elif event.is_action_released("perk"): # Tecla no apretada
		perk_activated = false

func _on_extra_physics_process() -> void:
	if perk_activated:
		if get_node("Cooldown_Cake_Perk").time_left == 0:
			create_cake()

func create_cake() -> void:
	if reduce_energy(60, 2.2):
		var cake_instance = load("res://Scenes/Player/Creamy_Slime/cake_trap.tscn").instantiate()
		Vars.main_scene.get_node("Summons").add_child(cake_instance)
		cake_instance.global_position = global_position
		get_node("Cooldown_Cake_Perk").start()

extends Player

func _input(event) -> void:
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

var summon_progress := 0
var glacibot := preload("res://Scenes/Player/White_Slime/glacibot.tscn")
func _on_extra_physics_process():
	if perk_activated:
		if reduce_energy(1, 1.2):
			summon_progress += 1
			if summon_progress % 5 == 0: particles()
		if summon_progress >= 80:
			if Vars.main_scene.has_node("Summons"):
				Funcs.sound_play_2d("res://Sounds/Life_Regen.mp3", global_position, 14, 1.4)
				var glacibot_instance := glacibot.instantiate()
				Vars.main_scene.get_node("Summons").add_child(glacibot_instance)
				glacibot_instance.global_position = global_position
				summon_progress = 0
	else:
		summon_progress = 0 # Si la tecla no esta apretada, reiniciar progreso

func particles():
	Funcs.particles(Vector2(0.025 * summon_progress, 0.025 * summon_progress), global_position, Color(0.737, 0.824, 1))

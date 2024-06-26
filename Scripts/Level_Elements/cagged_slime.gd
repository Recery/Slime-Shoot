extends Activable

@export var slime_to_unlock : PackedScene

func _input(event) -> void:
	if event.is_action_pressed("interact") and player_in_area:
		activated.emit(self)

func _on_activated(_emitter) -> void:
	add_child(load("res://Scenes/Useful/confetti_effect.tscn").instantiate())
	
	Vars.slimes_unlocked.append(slime_to_unlock)
	Save_System.save_unlocked_slimes()
	
	get_node("AnimationPlayer").current_animation = "bounce_free"
	f_key.queue_free()
	await get_tree().create_timer(1).timeout
	await Funcs.fade_effect(get_node("Sprite2D"))
	queue_free()

extends Node2D

var coffee_trail = preload("res://Scenes/Passives/coffee_trail.tscn")

func _on_create_trail_timer_timeout():
	var coffee_trail_instance := coffee_trail.instantiate()
	if not await Funcs.add_to_summons_deferred(coffee_trail_instance, Vars.player.global_position):
		coffee_trail_instance.queue_free()

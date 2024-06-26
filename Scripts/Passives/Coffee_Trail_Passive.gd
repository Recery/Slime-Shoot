extends Node2D

var coffee_trail = preload("res://Scenes/Passives/coffee_trail.tscn")

func _on_create_trail_timer_timeout():
	var coffee_trail_instance = coffee_trail.instantiate()
	coffee_trail_instance.global_position = Vars.player.global_position
	Vars.main_scene.get_node("Summons").add_child(coffee_trail_instance)

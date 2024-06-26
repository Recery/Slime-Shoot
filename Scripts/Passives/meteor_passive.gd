extends Node2D

var meteor := preload("res://Scenes/Passives/meteor.tscn")

func _on_spawn_timer_timeout():
	spawn_meteor()

func spawn_meteor() -> void:
	var meteor_instance := meteor.instantiate()
	if not Funcs.add_to_bullets(meteor_instance): return
	
	var mouse_pos := Vars.player.get_local_mouse_position()
	var spawn_pos := Vector2.ZERO
	spawn_pos.y = Vars.player.global_position.y - 100
	if mouse_pos.x < 0:
		spawn_pos.x = Vars.player.global_position.x + 100
	else:
		spawn_pos.x = Vars.player.global_position.x - 100
	
	meteor_instance.global_position = spawn_pos
	meteor_instance.direction = (Vars.player.to_global(mouse_pos) - spawn_pos).normalized()
	meteor_instance.rotation = Funcs.get_angle(Vars.player.to_global(mouse_pos), spawn_pos) - 1.57

extends Node2D

func _on_summon_vine_timer_timeout():
	var target_enemy := get_nearest_enemy()
	if target_enemy != null:
		target_enemy.add_to_group("Electric_Vine_Trapped")
		target_enemy.add_child(get_vine())

var vine := preload("res://Scenes/Passives/electric_vine.tscn")
func get_vine():
	var vine_instance := vine.instantiate()
	return vine_instance

func get_nearest_enemy() -> Node2D:
	if Vars.player == null: return
	var exceptions := []
	
	for i in range(10):
		var enemy = Funcs.scan_for_enemy(100, null, Vars.player, exceptions)
		if enemy == null: continue
		if enemy.is_in_group("Electric_Vine_Trapped") or enemy.is_in_group("Boss") or enemy.waiting_player:
			exceptions.append(enemy)
			continue
		return enemy
	
	return null

extends Ability

#const cooldown = 12
#const starter_cooldown = 6

func _on_activate():
	get_node("Use_Sound").play()
	player.add_child(load("res://Scenes/Abilities/freeze_ability_attack.tscn").instantiate())

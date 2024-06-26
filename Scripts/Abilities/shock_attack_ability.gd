extends Ability

func _on_activate():
	get_node("Use_Sound").play()
	player.add_child(load("res://Scenes/Abilities/shock_attack.tscn").instantiate())

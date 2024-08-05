extends Enemy

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 2, true)

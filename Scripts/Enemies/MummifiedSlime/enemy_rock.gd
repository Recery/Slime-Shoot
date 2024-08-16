extends Enemy_Projectile

func _on_area_entered(area):
	if area.is_in_group("Player_Slime"):
		die.emit()

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 4, true)

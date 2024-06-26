extends Enemy_Projectile

func _on_area_entered(area):
	if area.is_in_group("Player_Slime"):
		die.emit()

func _on_die():
	Funcs.color_explosion(0.5,0.5,global_position, Funcs.get_bullets_node(), 0, false, Color.html("#4e495f"))

extends Enemy_Projectile

func _on_area_entered(area):
	if area.is_in_group("Player_Slime"):
		die.emit()

func _on_despawn_timer_timeout():
	die.emit()

func _on_die():
	Funcs.regular_explosion(0.8, 0.8, global_position, Funcs.get_bullets_node(), 5, true)

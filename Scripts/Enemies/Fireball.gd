extends Enemy_Projectile

func _on_area_entered(area) -> void:
	if area.is_in_group("Player_Slime"):
		die.emit()

func _on_die() -> void:
	Funcs.regular_explosion(0.7, 0.7, global_position, Vars.main_scene.get_node_or_null("Bullets"), 0, false)
	queue_free()

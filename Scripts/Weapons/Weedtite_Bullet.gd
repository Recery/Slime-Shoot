extends Friendly_Projectile

func _on_body_entered(body):
	if !body.is_in_group("Player_Slime"):
		if body.is_in_group("Enemies") && !stop_working:
			Funcs.deal_damage(body, damage)
		die.emit()

func _on_die():
	Funcs.regular_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 0, false)

extends Friendly_Projectile

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or stop_working: return
	
	Funcs.deal_damage(body, damage)
	die.emit()

func _on_die():
	Funcs.regular_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 0, false)

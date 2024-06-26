extends Friendly_Projectile

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or body == null or stop_working: return
	
	Funcs.deal_damage(body,damage)
	if Vars.player.life + 3 <= Vars.player.max_life:
		Vars.player.life += 3
	else: Vars.player.life = Vars.player.max_life
	
	die.emit()

func _on_die():
	stop_working = true
	Funcs.color_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 2, true, Color.RED)

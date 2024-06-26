extends Friendly_Projectile

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or stop_working: return
	
	body.add_child(get_chill_debuff())
	Funcs.deal_damage(body, damage)
	die.emit()

func get_chill_debuff() -> Buff:
	var chill_debuff := Buff.new()
	chill_debuff.duration = 1.5
	chill_debuff.enemy_color = Color(0.639, 0.757, 1)
	chill_debuff.stat_to_modify = "Speed"
	chill_debuff.weight_to_modify = 1.75
	chill_debuff.name = "Chill_Debuff"
	return chill_debuff


func _on_die():
	Funcs.color_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 2, true, Color(0.737, 0.824, 1))

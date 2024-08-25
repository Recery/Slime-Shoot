extends Friendly_Projectile

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or body == null: return
	body.add_child(get_freeze_debuff())
	
	if not stop_working: die.emit()

func get_freeze_debuff() -> Buff_Speed_Enemy:
	var debuff := Buff_Speed_Enemy.new()
	debuff.weight_to_modify = 0
	debuff.duration = 1.5
	debuff.color = Color(0.639, 0.757, 1)
	return debuff

func _on_die():
	stop_working = true
	hide()
	get_node("CollisionShape2D").scale = Vector2(3,3)
	Funcs.color_explosion(1, 1, global_position, Funcs.get_bullets_node(), 2, true, Color.GHOST_WHITE)

extends Enemy_Projectile

func _on_area_entered(area):
	if area.is_in_group("Player_Slime"):
		die.emit()

func _on_die():
	get_node("CollisionShape2D").scale = Vector2(3,3)
	for area in get_overlapping_areas():
		if area.is_in_group("Player_Slime"):
			if not area.get_parent().has_node("Frozen_Bomber_Slowness"):
				# No tiene el debuff, aplicarlo
				area.get_parent().add_child(get_speed_debuff())
			else:
				# Tiene el debuff. No aplicarlo, sino reiniciarlo
				var debuff = area.get_parent().get_node("Frozen_Bomber_Slowness")
				if debuff.duration_timer != null:
					debuff.duration_timer.start()
			break
	Funcs.color_explosion(1.1, 1.1, global_position, Funcs.get_bullets_node(), 3, true, Color.SKY_BLUE)

func get_speed_debuff() -> Buff_Player:
	var debuff := Buff_Player.new()
	debuff.name = "Frozen_Bomber_Slowness"
	debuff.speed_weight_to_modify = 0.9
	debuff.player_color = Color.SKY_BLUE
	debuff.duration = 2
	return debuff

extends Enemy_Projectile

var dead_by_player := false

func _on_area_entered(area):
	if area.is_in_group("Player_Slime"):
		dead_by_player = true
		die.emit()

func _on_die():
	if dead_by_player:
		Funcs.strike_effect(Vector2(1,1),global_position)

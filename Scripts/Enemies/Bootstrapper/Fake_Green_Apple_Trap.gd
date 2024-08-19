extends Enemy_Projectile

func _on_area_entered(area):
	if not area.is_in_group("Player_Slime"): return
	if Vars.player == null: return
	
	

func get_damage_debuff():
	var debuff := Buff_Player.new()
	debuff

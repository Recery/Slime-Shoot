extends Enemy_Projectile

@onready var collision := get_node("CollisionShape2D")
func _on_area_entered(area):
	if not area.is_in_group("Player_Slime"): return
	
	if Vars.player != null and Vars.player is Player:
		if not Vars.player.reduce_energy(Vars.player.energy, 1):
			# Si no le reduce la energia, directamente ponerla en 0
			Vars.player.energy = 0
		get_node("Trap").frame = 1
		collision.set_deferred("disabled", true)
		
		# Que no monitoree areas para no volver a sacar energia, y que sea monitoreable para que el jugador lo detecte
		set_deferred("monitoring", false)
		set_deferred("monitorable", true)
		get_node("Use_Sound").play()
		get_node("Activated_Sound").play()
		
		await get_tree().create_timer(3, false).timeout
		die.emit()

func _on_die():
	collision.set_deferred("disabled", false)
	collision.scale = Vector2(2,2)
	Funcs.regular_explosion(1.4, 1.4, global_position, Funcs.get_bullets_node(), 4, true)

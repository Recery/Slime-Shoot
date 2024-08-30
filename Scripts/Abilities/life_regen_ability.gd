extends Ability

var life_added := 0

func _on_activate():
	life_added = 0
	get_node("Regen_Timer").start()
	get_node("Use_Sound").play()
	for i in 5:
		await get_tree().create_timer(0.08, false).timeout
		Funcs.particles(Vector2(1.5,1.5), Vector2(player.global_position.x, player.global_position.y-(i*3)), Color(1, 0.337, 0.271), player)

func _on_regen_timer_timeout():
	if  life_added < 20 && player.life > 0: 
		if player.life < player.max_life: player.life += 1
		if life_added % 2 != 0:
			# Si la vida añadida hasta ahora es par, genera particulas
			# Esa comprobacion solo es por estetica, para que no se generen muchas particulas al mismo tiempo
			Funcs.particles(Vector2(2.2,1.8), player.global_position, Color(1, 0.337, 0.271), player)
		life_added += 1
	else: get_node("Regen_Timer").stop()

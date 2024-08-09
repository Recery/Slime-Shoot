extends Friendly_Projectile

var fart_poison := preload("res://Scenes/Weapons/fart_poison.tscn")

func attack_effects():
	create_particles()
	Funcs.color_explosion(4, 4, global_position, Funcs.get_bullets_node(), 0, false, Color.WEB_GREEN)

func _on_body_entered(body):
	if not body.is_in_group("Enemies"): return
	
	if not body.has_node("Fart_Poison_Slime"):
		body.add_child(get_fart_debuff())
	else:
		body.get_node("Fart_Poison_Slime").reset_timer()
	Funcs.deal_damage(body, damage)

func get_fart_debuff() -> Node:
	var poison_instance := fart_poison.instantiate()
	if poison_instance.has_node("Despawn_Timer"):
		poison_instance.get_node("Despawn_Timer").wait_time = 4
	poison_instance.name = "Fart_Poison_Slime"
	return poison_instance

func create_particles():
	for i in range(9):
		var angle = i * (2 * PI / 9)
		var x = global_position.x + 20 * cos(angle)
		var y = global_position.y + 20 * sin(angle)
		Funcs.particles(Vector2(0.8,0.8), Vector2(x,y), Color.WEB_GREEN)
	
	for i in range(18):
		var angle = i * (2 * PI / 18)
		var x = global_position.x + 40 * cos(angle)
		var y = global_position.y + 40 * sin(angle)
		Funcs.particles(Vector2(0.8,0.8), Vector2(x,y), Color.WEB_GREEN)

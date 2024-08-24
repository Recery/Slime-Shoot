extends Weapon

@onready var use_sound := get_node("Use_Sound")
func _on_shoot():
	damage_area.monitoring = true
	player.custom_velocity = true
	rotation_activated = false
	use_sound.play()
	
	if flip_v:
		rotation_degrees -= 45
		damage_area.rotation_degrees = 90
	else:
		rotation_degrees += 45
		damage_area.rotation_degrees = 0
	
	var dir = (player.shoot_pos - player.global_position).normalized()
	player.velocity = dir * (abs(player.speed) * 1.1)
	if Funcs.get_current_cooldown(self) <= 0.8:
		await get_tree().create_timer(Funcs.get_current_cooldown(self) * 0.9).timeout
	else: await get_tree().create_timer(0.8).timeout
	
	damage_area.monitoring = false
	player.custom_velocity = false
	player.forced_immunity = false
	rotation_activated = true

@onready var damage_area := get_node("Goldfish_Trident_Damage")
func _extra_process():
	if damage_area.monitoring:
		player.forced_immunity = true
		Funcs.smoke_effect(Vector2.ONE, player.global_position)

func _on_goldfish_trident_damage_body_entered(body):
	if not body.is_in_group("Enemies"): return
	
	Funcs.deal_damage(body, damage_area.damage)

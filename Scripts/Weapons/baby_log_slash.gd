extends Friendly_Projectile

var first_damage

var damaged_enemies = []

func _ready():
	first_damage = true

func _on_body_entered(body):
	if not body.is_in_group("Enemies"): return
	
	Funcs.strike_effect(Vector2(1,1), global_position)
	if first_damage:
		Funcs.deal_damage(body, damage)
		body.add_child(Knockback.new(150))
		first_damage = false
		damaged_enemies.append(body)
	elif not damaged_enemies.has(body):
		var area_damage = (damage / original_damage) * (original_damage - 2) # Fórmula para obtener el daño correcto de área
		Funcs.deal_damage(body, area_damage)
		body.add_child(Knockback.new(150))
		damaged_enemies.append(body)

func _on_animation_player_animation_finished(_anim_name):
	queue_free()

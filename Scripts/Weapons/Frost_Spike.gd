extends Friendly_Projectile

var enemies_damaged

func _ready():
	enemies_damaged = 0
	if direction.x < 0: get_node("Sprite2D").flip_v = true

func _physics_process(delta):
	if !stop_working:
		global_position += direction * speed * delta

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		if body.is_in_group("Enemies") && !stop_working && enemies_damaged < 3:
			Funcs.deal_damage(body, damage)
			Funcs.dash_smoke(1, 1, global_position)
			enemies_damaged += 1
			if not body.has_node("Frost_Staff_Debuff"):
				body.add_child(get_chill_debuff())
			else:
				body.get_node("Frost_Staff_Debuff").reset_duration()
		
		if enemies_damaged >= 3: die.emit()

func _on_particles_timer_timeout():
	Funcs.particles(Vector2(randf_range(1.0, 1.2), randf_range(1.0, 1.2)), global_position, Color(0.737, 0.824, 1))

var already_exploded = false
func _on_die():
	if not already_exploded: Funcs.color_explosion(0.6, 0.6, global_position, Funcs.get_bullets_node(), 2, true, Color(0.737, 0.824, 1))
	already_exploded = true

func get_chill_debuff() -> Buff_Speed_Enemy:
	var chill_debuff := Buff_Speed_Enemy.new()
	chill_debuff.duration = 2
	chill_debuff.color = Color(0.639, 0.757, 1)
	chill_debuff.weight_to_modify = 0.75
	chill_debuff.name = "Frost_Staff_Debuff"
	return chill_debuff

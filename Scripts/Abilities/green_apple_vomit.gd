extends Friendly_Projectile

@onready var sprite := get_node("AnimatedSprite2D")
var enemies_inside := []

func _ready():
	rotation = Funcs.get_angle(Vars.player.shoot_pos, Vars.player.global_position)
	get_node("Vomit_Sizzle").play()

func _extra_physics_process():
	if Vars.player != null:
		rotation = lerp_angle(rotation, Funcs.get_angle(Vars.player.shoot_pos, Vars.player.global_position), 0.08)
		global_position = Vars.player.global_position
		if Vars.player.life <= 0: die.emit()

func _on_body_entered(body):
	if not body.is_in_group("Enemies"): return
	if not enemies_inside.has(body):
		enemies_inside.append(body)

func _on_body_exited(body):
	if enemies_inside.has(body):
		enemies_inside.erase(body)

func _on_effects_timer_timeout():
	create_particles()
	for enemy in enemies_inside:
		if enemy == null: continue
		Funcs.deal_damage(enemy, damage)
		if not enemy.has_node("Green_Apple_Debuff"):
			enemy.add_child(get_damage_debuff())

func get_damage_debuff() -> Buff_Damage_Enemy:
	var damage_debuff := Buff_Damage_Enemy.new()
	damage_debuff.duration = 8
	damage_debuff.weight_to_modify = 0.5
	damage_debuff.color = Color.YELLOW_GREEN
	damage_debuff.name = "Green_Apple_Debuff"
	return damage_debuff

func _on_animated_sprite_2d_animation_finished():
	sprite.play("stand")

func _on_die():
	sprite.play("vomit_end")

func create_particles():
	for i in 5:
		var pos := to_global(Vector2((i+1) * 25, 0))
		Funcs.particles(Vector2(1.5,1.5), pos, Color.YELLOW_GREEN)

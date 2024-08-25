extends Friendly_Projectile

var attached_enemy : Node2D

func _ready():
	attached_enemy = get_parent()
	
	if attached_enemy != null and attached_enemy is Enemy:
		attached_enemy.add_child(get_deal_damage_debuff())
		attached_enemy.add_child(get_speed_debuff())
		attached_enemy.apply_new_speed()
		attached_enemy.die.connect(func(): die.emit())

func get_deal_damage_debuff() -> Buff_Life_Enemy:
	var debuff := Buff_Life_Enemy.new()
	debuff.life_to_add = -attached_enemy.max_life
	debuff.iterations = attached_enemy.max_life
	debuff.duration = attached_enemy.max_life
	debuff.color = Color.CORNFLOWER_BLUE
	debuff.tree_exiting.connect(check_dead_enemy)
	return debuff

func get_speed_debuff() -> Buff_Speed_Enemy:
	var debuff := Buff_Speed_Enemy.new()
	debuff.duration = 0
	debuff.weight_to_modify = 0
	return debuff

func check_dead_enemy():
	if attached_enemy != null:
		attached_enemy.add_child.call_deferred(get_deal_damage_debuff())
	else: die.emit()

func _on_die():
	Funcs.color_explosion(0.8, 0.8, global_position, Funcs.get_bullets_node(), 0, false, Color.CORNFLOWER_BLUE)

# Este método es para hacer daño a los enemigos alrededor, no al enemigo atrapado
func _on_damage_timer_timeout():
	var damaged_enemies := 0
	for body in get_overlapping_bodies():
		if damaged_enemies > 5: return
		if body.is_in_group("Enemies") and body != attached_enemy:
			Funcs.deal_damage(body, damage)
			Funcs.shock_visual(global_position, body.global_position)
			damaged_enemies += 1

@onready var shock_sound := get_node("Shock_Sound")
func _on_shock_sound_finished():
	shock_sound.play()

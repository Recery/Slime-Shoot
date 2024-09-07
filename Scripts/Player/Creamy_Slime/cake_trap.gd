extends Friendly_Projectile

var enemies_damaged
var attracted_enemies = []

func _ready():
	enemies_damaged = 0
	check_other_cakes()

func _on_scan_enemies_timeout():
	var detected_enemy = null
	detected_enemy = Funcs.scan_for_enemy(85, detected_enemy, self, attracted_enemies)
	if detected_enemy != null and attracted_enemies.size() < 3 and not detected_enemy.custom_target_position_setted and not detected_enemy.is_in_group("Big_Enemies") and not detected_enemy.is_in_group("Boss"):
		attracted_enemies.append(detected_enemy)
		detected_enemy.set_custom_target_position(global_position)
		
		if get_node("Explode_Timer").time_left == 0:
			get_node("Explode_Timer").start()
			get_node("AnimationPlayer").current_animation = "blink_faster"

func check_other_cakes() -> void:
	# Cuenta la cantidad de tortas que hay en en juego.
	# El límite es 5, si hay más de esa cantidad entonces explota la más antigua.
	var main_scene_children := Funcs.get_all_children(Vars.main_scene)
	var cake_amount := 0
	for child in main_scene_children:
		if child.is_in_group("Cake_Trap"): cake_amount += 1
	
	if cake_amount > 5:
		for child in main_scene_children:
			if child.is_in_group("Cake_Trap"): 
				child._on_explode_timer_timeout()
				return

func _on_explode_timer_timeout():
	monitoring = true
	for enemy in attracted_enemies:
		if enemy != null:
			enemy.reset_custom_target_position()
	Funcs.sound_play("res://Sounds/Cake_Explosion.mp3", 1, 0.8)
	die.emit()

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		if body.is_in_group("Enemies") and not stop_working and enemies_damaged < 5:
			Funcs.deal_damage(body, damage)
			enemies_damaged += 1

func _on_die():
	Funcs.color_explosion(2.5, 2.5, global_position, Funcs.get_bullets_node(), 0, false, Color.PINK)

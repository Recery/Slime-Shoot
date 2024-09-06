extends Enemy

var life_bar

var attack_phase : int
var can_attack : bool

func _ready() -> void:
	attack_phase = 0
	can_attack = false
	get_node("Attack_Timer").start()
	
	Vars.main_scene.get_node("Music").stop()
	get_node("Music").play()
	get_node("Laugh_Begin").play()
	
	visible = true
	create_life_bar()
	spawn_effect()


@onready var sprite := get_node("Sprite2D")
@onready var animation := get_node("AnimationPlayer")
func _physics_process(_delta) -> void:
	life_bar.set_current_value(life)
	
	if global_position.distance_to(player.global_position) < 150 and can_attack and not is_in_group("Full_Freezed"):
		# Atacar
		can_attack = false
		animation.current_animation = "attack"
		moving = false
		force_pathfinding_update()
		match attack_phase:
			0: fireball_hell()
			1: explosion()
		attack_phase += 1
		if attack_phase >= 2: attack_phase = 0
	elif animation.current_animation == "walk" and not is_in_group("Full_Freezed"):
		moving = true
		if player.global_position.x < global_position.x: sprite.flip_h = true
		else: sprite.flip_h = false
	else:
		moving = false
	
	if player.life <= 0: get_node("Music").stop()

func fireball_hell() -> void:
	var fireball = preload("res://Scenes/Enemies/fireball.tscn")
	var shot_center = get_node("Shot_Center")
	var bullets_node = Funcs.get_bullets_node()
	
	play_sound()
	await get_tree().create_timer(1, false).timeout
	shot_center.rotation_degrees = 0
	while shot_center.rotation_degrees <= 180:
		await get_tree().create_timer(0.2, false).timeout
		for i in range(4):
			var fireball_instance = fireball.instantiate()
			var shot_pos = get_node("Shot_Center/Shot_Pos_" + str(i+1))
			var shoot_dir = (shot_pos.global_position - shot_center.global_position).normalized()
			
			bullets_node.add_child(fireball_instance)
			fireball_instance.rotation = Funcs.get_angle(shot_pos.global_position, shot_center.global_position) + 1.5708
			fireball_instance.global_position = shot_center.global_position
			fireball_instance.direction = shoot_dir
		shot_center.rotation_degrees += 10
	
	get_node("Attack_Timer").start()
	get_node("AnimationPlayer").current_animation = "walk"

func explosion():
	play_sound()
	get_node("Circle_Explosion").show()
	await get_tree().create_timer(2, false).timeout
	
	get_node("Explosion_Area").set_deferred("monitoring", true)
	
	Funcs.regular_explosion(6, 6, global_position, Vars.main_scene, 12, true)
	await get_tree().create_timer(0.2).timeout
	
	get_node("Explosion_Area").set_deferred("monitoring", false)
	get_node("Circle_Explosion").hide()
	
	get_node("Attack_Timer").start()
	get_node("AnimationPlayer").current_animation = "walk"

func _on_explosion_area_body_entered(body) -> void:
	if body.is_in_group("Player_Slime"):
		body.deal_damage_special(damage * 3, true)
	get_node("Explosion_Area").set_deferred("monitoring", false)

func play_sound():
	if Funcs.probability(50): get_node("Laugh").play()
	else: get_node("Horn").play()

func spawn_effect():
	get_node("Sprite2D").hide()
	moving = false
	
	var smoke_instance = load("res://Scenes/Useful/boss_smoke.tscn").instantiate()
	add_child(smoke_instance)
	smoke_instance.modulate.a = 0
	
	await Funcs.fade_effect(smoke_instance, true)
	await get_tree().create_timer(1.5).timeout
	
	get_node("Sprite2D").show()
	get_node("CollisionPolygon2D").disabled = false
	
	await Funcs.fade_effect(smoke_instance, false)
	smoke_instance.queue_free()
	moving = true
	get_node("AnimationPlayer").current_animation = "walk"

func create_life_bar():
	await ready
	life_bar = load("res://Scenes/Useful/progress_bar.tscn").instantiate()
	player.add_child(life_bar)
	life_bar.position = Vector2(-48.5, -53)
	life_bar.set_color(Color.RED)
	life_bar.max_value = max_life
	life_bar.min_value = 0
	life_bar.set_current_value(max_life)

func _on_die():
	life_bar.queue_free()
	Funcs.regular_explosion(6, 6, global_position, Vars.main_scene, 20, true)
	Vars.main_scene.get_node("Music").play()

func _on_attack_timer_timeout() -> void:
	can_attack = true
	get_node("Attack_Timer").stop()

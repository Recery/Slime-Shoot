extends Enemy

@onready var sprite := get_node("AnimatedSprite2D")

var setting_traps := false
func _physics_process(delta):
	if target_enemy != null:
		for orb in life_orbs:
			if orb == null: continue
			var orb_dir : Vector2 = (target_enemy.global_position - orb.global_position).normalized()
			orb.global_position += orb_dir * (abs(target_enemy.speed) * 1.5) * delta
			orb.rotation = dir.angle()
			if orb.global_position.distance_to(target_enemy.global_position) < 5:
				Funcs.heal_enemy(target_enemy, damage / 2)
				Funcs.color_explosion(0.75, 0.75, target_enemy.global_position, player, 0, false, Color.ORANGE_RED)
				orb.queue_free()
	else: for orb in life_orbs: if orb != null: orb.queue_free()
	
	Funcs.remove_array_elements(life_orbs, null)
	
	if is_in_group("Full_Freezed"): sprite.stop()
	elif not sprite.is_playing(): sprite.play()
	
	if velocity != Vector2.ZERO: sprite.animation = "walk"
	else: sprite.animation = "attack"

var target_enemy : Node
func get_target_enemy():
	var exceptions := [self] # Excepciones al escanear enemigos
	for i in 10:
		var enemy = Funcs.scan_for_enemy(150, target_enemy, self, exceptions)
		if enemy == null: continue
		if not enemy.is_in_group("Bootstrapper"):
			target_enemy = enemy
			break
		else: exceptions.append(enemy)
	
	spawn_life_orb()

var life_orb_texture := preload("res://Sprites/Enemies/Bootstrapper/LifeOrb.png")
var life_orbs : Array[Sprite2D]
func spawn_life_orb():
	var life_orb := Sprite2D.new()
	if Funcs.add_to_bullets(life_orb):
		life_orb.texture = life_orb_texture
		life_orb.modulate.a = 0.75
		life_orb.global_position = global_position
		life_orb.add_child(Timered_Particles.new(0, 0.05, Color.ORANGE,Vector2.ONE))
		life_orbs.append(life_orb)
	else: life_orb.queue_free()

@onready var trap_sound := get_node("Trap_Sound")
@onready var heal_sound := get_node("Heal_Sound")
func attack():
	setting_traps = not setting_traps
	
	moving = false
	apply_new_speed()
	await get_tree().create_timer(1, false).timeout
	
	if not setting_traps:
		get_target_enemy()
		heal_sound.play()
	else: 
		match randi_range(0,2):
			0: create_energy_drain_trap()
			1: create_fake_green_apple_trap()
			2: create_hipnotic_trap()
		trap_sound.play()
	
	moving = true

var energy_drain_trap := preload("res://Scenes/Enemies/Bootstrapper/energy_drain_trap.tscn")
func create_energy_drain_trap():
	var energy_drain_trap_instance := energy_drain_trap.instantiate()
	
	if Funcs.add_to_summons(energy_drain_trap_instance):
		energy_drain_trap_instance.damage = damage * 1.8
		energy_drain_trap_instance.global_position = global_position
	else: energy_drain_trap_instance.queue_free()

var fake_green_apple_trap := preload("res://Scenes/Enemies/Bootstrapper/fake_green_apple_trap.tscn")
func create_fake_green_apple_trap():
	var fake_green_apple_instance := fake_green_apple_trap.instantiate()
	
	if Funcs.add_to_summons(fake_green_apple_instance):
		fake_green_apple_instance.damage = max(damage / 2, 1)
		fake_green_apple_instance.global_position = global_position
	else: fake_green_apple_instance.queue_free()

var hipnotic_trap := preload("res://Scenes/Enemies/Bootstrapper/hipnotic_trap.tscn")
func create_hipnotic_trap():
	var hipnotic_trap_instance := hipnotic_trap.instantiate()
	
	if Funcs.add_to_summons(hipnotic_trap_instance):
		hipnotic_trap_instance.global_position = global_position
	else: hipnotic_trap_instance.queue_free()

func _exit_tree():
	for orb in life_orbs: if orb != null: orb.queue_free()

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 2, true)

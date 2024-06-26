extends Player

@onready var cooldown_active = false

var perk_attack_cooldown

func _on_ready():
	create_perk_attack_cooldown()

func create_perk_attack_cooldown():
	perk_attack_cooldown = Timer.new()
	add_child(perk_attack_cooldown)
	perk_attack_cooldown.connect("timeout", _on_perk_attack_cooldown_timeout)

func _input(event) -> void:
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

func _on_extra_physics_process() -> void:
	if perk_activated: # Tecla apretada
		if reduce_energy(1.2):
			if not cooldown_active:
				get_node("Animation_Player_Slime").current_animation = "bounce_shock"
				play_sound()
				perk_attack_cooldown.start(0.5)
				cooldown_active = true
		else:
			perk_activated = false
	else: # Tecla no apretada
		if cooldown_active:
			perk_attack_cooldown.stop()
			cooldown_active = false
			get_node("Animation_Player_Slime").current_animation = "bounce_shadow"

func _on_perk_attack_cooldown_timeout():
	play_sound()
	for enemy in enemies_attacking:
		if enemy != null:
			enemy.add_child(load("res://Scenes/Player/Yellow_Slime/shock_perk_damage.tscn").instantiate())

func play_sound() -> void:
	for i in range(3):
		if not perk_activated: return
		Funcs.sound_play("res://Sounds/ElectricZap.mp3", 4, 1.4)
		await get_tree().create_timer(0.22).timeout

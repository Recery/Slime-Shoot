extends Weapon

var current_speed_buff : Buff_Player
var green_apple := preload("res://Scenes/Abilities/green_apple.tscn")
@onready var crazy_sound := get_node("Crazy_Sound")
@onready var use_sound := get_node("Use_Sound")
@onready var sizzle_sound := get_node("Sizzle_Sound")
@onready var animation := get_node("AnimationPlayer")

func _physics_process(_delta):
	if not active:
		visible = false
		if current_speed_buff != null:
			current_speed_buff.remove_buff()
		return
	else:
		visible = not broken
		if not crazy_sound.is_playing() and not broken:
			crazy_sound.play()
		if current_speed_buff == null and not broken:
			current_speed_buff = get_speed_buff()
			player.add_child(current_speed_buff)
		elif current_speed_buff != null and broken: # Si el jugador rompio el palito, la manzana verde ya no esta y hay que remover la velocidad extra
			current_speed_buff.remove_buff()
	
	if Input.is_action_pressed("shoot") and can_shoot:
		if player.reduce_energy(energy_use, energy_recover_cooldown): shoot.emit()
	
	Funcs.weapon_rotation(self, hold_offset)
	shake_effect()

func get_speed_buff() -> Buff_Player:
	var buff := Buff_Player.new()
	buff.speed_weight_to_modify = 1.20
	return buff

var shaking := false
func shake_effect():
	if shaking or not can_shoot: return
	shaking = true
	
	var original_pos := position
	var rand_extra_pos := Vector2(randi_range(-1, 1), randi_range(-1, 1))
	position = original_pos + rand_extra_pos
	await get_tree().create_timer(0.05).timeout
	position = original_pos
	
	shaking = false


# Parte de activacion del arma
var broken := false
func _on_shoot():
	# Efectos
	use_sound.play()
	animation.current_animation = "break"
	Funcs.dash_smoke(1,1, Vector2(global_position.x, global_position.y - 6))
	await animation.animation_finished
	
	broken = true
	var apple_instance := green_apple.instantiate()
	player.add_child(apple_instance)
	apple_instance.play("normal")
	apple_instance.frame_changed.connect(_on_apple_frame_changed)
	
	# Fin efectos

func damage_conection():
	# Se comio la manzana, aplicar los efectos que la manzana le da al jugador (Y el sonido)
	sizzle_sound.play()
	
	# Conecta esto para recibir cuando se añadio un nuevo nodo al arbol, que podria llegar a ser un proyectil, para aumentar el daño
	if not get_tree().node_added.is_connected(add_damage):
		get_tree().node_added.connect(add_damage)
	
	print(Funcs.get_cooldown_timeleft(self))
	Funcs.timed_particles(Vector2(2,2), Funcs.get_cooldown_timeleft(self), Color.GREEN_YELLOW, player)
	await get_tree().create_timer(Funcs.get_cooldown_timeleft(self)).timeout
	
	# Chau manzana, desconectar el daño
	if get_tree().node_added.is_connected(add_damage):
		get_tree().node_added.disconnect(add_damage)
	normal_damage()
	
	# Resetear efectos
	sizzle_sound.stop()
	broken = false
	frame = 0

var weapons_affected := []
func add_damage(weapon) -> void:
	if not weapon.is_in_group("Friendly_Damage"): return
	if "damage" not in weapon: return
	if weapon.original_damage == 0: return
	if weapons_affected.has(weapon): return
	
	if not weapon.is_node_ready(): await weapon.ready
	weapons_affected.append(weapon)
	if weapon is Friendly_Projectile:
		if not weapon.has_node("Green_Apple_Damage"):
			weapon.add_child(get_damage_node())
	else: weapon.damage += 1

func normal_damage() -> void:
	for weapon in weapons_affected:
		if weapon == null: continue
		
		if weapon is Friendly_Projectile:
			if weapon.has_node("Green_Apple_Damage"):
				weapon.get_node("Green_Apple_Damage").queue_free()
		else: weapon.damage = weapon.original_damage
		
	weapons_affected.resize(0)

func get_damage_node() -> Damage_Request:
	var dmg_rqst := Damage_Request.new()
	dmg_rqst.damage_to_add = 1
	dmg_rqst.name = "Green_Apple_Damage"
	return dmg_rqst

var frame_count := 0
func _on_apple_frame_changed():
	Funcs.sound_play("res://Sounds/Crunch.mp3", 20, 1.25)
	Funcs.particles(Vector2(1.5,1.5), player.global_position, Color.GREEN)
	if frame_count < 2:
		frame_count += 1
	elif player.has_node("Green_Apple"):
		frame_count = 0
		player.get_node("Green_Apple").queue_free()
		damage_conection()

extends Enemy

var shoot_pos := Vector2.ZERO
@onready var goldfish_trident := get_node("Goldfish_Trident")
@onready var rock := get_node("Rock")

var current_weapon : Enemy_Weapon
var second_phase := false

func _ready():
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").stop()
	
	goldfish_trident.shoot.connect(charge)
	
	rock.shoot.connect(rock_shoot)
	rock.recovered.connect(rock_recovered)
	current_weapon = rock
	
	life_module.take_damage.connect(_on_take_damage)
	create_life_bar()

const min_distance = 50 # La distancia minima a la que el boss puede estar del jugador (si es menos que esto se aleja del jugador)
const max_distance = 100 # La distancia maxima a la que el boss puede estar del jugador (si es mas que esto se acerca al jugador)
func _physics_process(_delta):
	life_bar.set_current_value(life)
	shoot_pos = Vars.player.global_position
	
	if not charging:
		if global_position.distance_to(player.global_position) > max_distance:
			go_backwards = false
		elif global_position.distance_to(player.global_position) < min_distance:
			go_backwards = true
		
		# Jerarquia de acciones directas que puede hacer el boss, la de arriba de todo es la prioritaria
		if is_on_wall(): # Si esta en la pared...
			# Ir hacia el jugador y despues de un tiempo retomar el movimiento normal (si no esta cargando con el tridente)
			go_backwards = false
			force_pathfinding_update()
			switch_pathfinding_cooldown(false)
			get_tree().create_timer(0.6).timeout.connect(func():
				if not charging: switch_pathfinding_cooldown(true))
		elif goldfish_trident.can_shoot: # Si puede usar el tridente...
			current_weapon = goldfish_trident
			goldfish_trident.timed_shoot.emit(0.8)
		elif rock.can_shoot: # Si puede usar la piedra...
			rock.timed_shoot.emit(1.1)
	
	immune = charging
	
	if player.life <= 0: get_node("Music").stop()
	weapons_visual()
	move_and_slide()

func weapons_visual():
	## Roca
	rock.manage_rotation()
	
	## Tridente goldfish
	if charging:
		goldfish_trident.manage_rotation(45)
		Funcs.dash_smoke(1, 1, global_position)
	else:
		goldfish_trident.manage_rotation()
	goldfish_trident.can_rotate = not charging
	
	rock.visible = current_weapon == rock
	goldfish_trident.visible = current_weapon == goldfish_trident

@onready var throw_sound := get_node("Throw_Sound")
var rock_proj := preload("res://Scenes/Enemies/MummifiedSlime/enemy_rock.tscn")
func rock_shoot(_alt_cooldown):
	# El tridente es el arma prioritaria a usar siempre que se pueda
	# Por eso el tridente controla cual es el arma actual y no la piedra
	if current_weapon != rock: return
	
	throw_sound.pitch_scale = 0.7
	throw_sound.play()
	rock.self_modulate.a = 0
	var rock_instance = rock_proj.instantiate()
	
	if Funcs.add_to_bullets(rock_instance):
		rock_instance.direction = (player.global_position - global_position).normalized()
		rock_instance.global_position = rock.global_position
		rock_instance.rotation = Funcs.get_angle(player.global_position, global_position)
	else: rock_instance.queue_free()

func rock_recovered():
	rock.self_modulate.a = 1
	Funcs.dash_smoke(0.8, 0.8, rock.global_position, 0.8, rock)

var charging := false
func charge(_alt_cooldown):
	charging = true
	throw_sound.pitch_scale = 0.6
	throw_sound.play()
	go_backwards = false
	add_child(get_speed_buff())
	add_child(get_damage_buff())
	force_pathfinding_update()
	switch_pathfinding_cooldown(false)
	await get_tree().create_timer(0.6).timeout
	charging = false
	current_weapon = rock
	switch_pathfinding_cooldown(true)

func get_speed_buff() -> Buff:
	var buff := Buff.new()
	buff.duration = 0.6
	buff.stat_to_modify = "Speed"
	buff.type = "Buff"
	buff.weight_to_modify = 1.75
	buff.name = "Mummified_Dash"
	return buff

func get_damage_buff() -> Buff:
	var buff := Buff.new()
	buff.duration = 0.6
	buff.stat_to_modify = "Damage"
	buff.type = "Buff"
	buff.weight_to_modify = 2
	buff.name = "Mummified_Damage"
	return buff

@onready var regen_sound := get_node("Regen_Sound")
func regen():
	if life > max_life * 0.75: return # Mucha vida, todavia no curar
	
	for i in 5:
		await get_tree().create_timer(0.08).timeout
		Funcs.particles(Vector2(1.5,1.5), Vector2(global_position.x, global_position.y-(i*3)), Color(1, 0.337, 0.271), self)
	
	regen_sound.pitch_scale = 1.1
	regen_sound.play()
	for i in range(20):
		life_module.heal(1)
		if i % 2 == 0: # Comprobación para que no se generen tantas particulas, solo cuando resultado par
			Funcs.particles(Vector2(2.2,1.8), global_position, Color(1, 0.337, 0.271), self)
		await get_tree().create_timer(0.25).timeout

var meteor := preload("res://Scenes/Enemies/MummifiedSlime/enemy_meteor.tscn")
var current_warning : Node
func spawn_meteor():
	if not second_phase: return # Solo invocar meteoritos en segunda fase
	
	# Asignar la posicion de explosion ahora para que sea siempre la misma
	# No se usa shoot_pos directamente ya que esa variable puede cambiar a lo largo de la funcion
	var meteor_pos := shoot_pos
	
	# Crear un sprite para advertir al jugador del meteorito
	var explosion_warning : Sprite2D = Funcs.explosion_warning(Vector2(3,3), meteor_pos)
	# Guarda el sprite de advertencia en esta variable para matarlo cuando sea necesario (Muerte del boss o del meteorito)
	current_warning = explosion_warning
	await get_tree().create_timer(1).timeout # Esperar un poco para dar tiempo de esquivar al jugador
	
	var meteor_instance := meteor.instantiate()
	meteor_instance.shoot_pos = meteor_pos
	if Funcs.add_to_bullets(meteor_instance):
		var spawn_pos := Vector2.ZERO
		spawn_pos.y = player.global_position.y - 100
		if meteor_pos.x < 0:
			spawn_pos.x = player.global_position.x + 100
		else:
			spawn_pos.x = player.global_position.x - 100
		
		meteor_instance.global_position = spawn_pos
		meteor_instance.direction = (meteor_pos - spawn_pos).normalized()
		meteor_instance.rotation = Funcs.get_angle(meteor_pos, spawn_pos) - 1.5
		
		meteor_instance.die.connect(kill_warning)
		
	else: meteor_instance.queue_free()

# Elimina la advertencia de explosion actual cuando muere el meteorito
func kill_warning():
	if current_warning != null: current_warning.queue_free()

var turret := preload("res://Scenes/Enemies/MummifiedSlime/enemy_laser_turret.tscn")
var current_turret : Node
func spawn_turret():
	if not second_phase: return # Solo invocar torretas en segunda fase
	
	if current_turret != null: current_turret.queue_free()
	
	regen_sound.pitch_scale = 1
	regen_sound.play()
	
	var turret_instance := turret.instantiate()
	if Funcs.add_to_summons(turret_instance):
		turret_instance.global_position = global_position
		current_turret = turret_instance
	else: turret_instance.queue_free()

var life_bar
func create_life_bar():
	await ready
	life_bar = load("res://Scenes/Useful/progress_bar.tscn").instantiate()
	player.add_child(life_bar)
	life_bar.position = Vector2(-48.5, -53)
	life_bar.set_color(Color.RED)
	life_bar.max_value = max_life
	life_bar.min_value = 0
	life_bar.set_current_value(max_life)

# Se usa para verificar si se debe activar la segunda fase
func _on_take_damage(_damage):
	if life < max_life / 2 and not second_phase:
		life_bar.set_color(Color.ORANGE)
		second_phase = true
		
		var rage_instance = load("res://Scenes/Abilities/rage_effect.tscn").instantiate()
		add_child(rage_instance)
		rage_instance.global_position = Vector2(global_position.x - 5, global_position.y - 2)
		
		rock.cooldown -= 0.3
		goldfish_trident.cooldown -= 0.4
		
		var particles_timer := Timer.new()
		add_child(particles_timer)
		particles_timer.start(0.2)
		particles_timer.timeout.connect(func(): Funcs.particles(Vector2(1.5,1.5), global_position, Color.YELLOW))
		
		Funcs.sound_play_2d("res://Sounds/Infinite_Energy.mp3", global_position, 9, 1.1)
		
		if life_module.take_damage.is_connected(_on_take_damage):
			life_module.take_damage.disconnect(_on_take_damage)

func _on_die():
	life_bar.queue_free()
	
	purify_animation()
	
	# Libera torretas y advertencias de explosion si quedo alguna despues de morir el jefe
	if current_warning != null: current_warning.queue_free()
	if current_turret != null: current_turret.queue_free()
	
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").play()

func purify_animation():
	# "Animacion" de purificar al slime al derrotarlo
	var goldfish_slime_animation = load("res://Scenes/Enemies/MummifiedSlime/freed_goldfish_slime.tscn").instantiate()
	
	if Vars.main_scene.has_node("Spawn_Position"):
		Vars.main_scene.get_node("Spawn_Position").add_child(goldfish_slime_animation)
		goldfish_slime_animation.global_position = global_position
		goldfish_slime_animation.activated.emit(goldfish_slime_animation)
	else: goldfish_slime_animation.queue_free()

extends Enemy

@onready var shoot_pos := get_node("Shoot_Pos")
@onready var sprite := get_node("Sprite2D")
@onready var dash_target_ray := get_node("Dash_Raycast") # Se usa para guardar la posicion de destino del dash y moverse en base a eso
@onready var dash_target := get_node("Dash_Raycast/Target")
@onready var collision := get_node("CollisionPolygon2D")

var dash_target_pos : Vector2

func _ready() -> void:
	Vars.main_scene.get_node("Music").stop()
	get_node("Music").play()
	
	set_shoot_timer()
	
	dash_target_pos = dash_target.global_position
	
	visible = true
	create_life_bar()
	spawn_effect()

func set_shoot_timer():
	var shoot_timer := Timer.new()
	add_child(shoot_timer)
	shoot_timer.start(4)
	shoot_timer.timeout.connect(shoot)

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

func spawn_effect():
	sprite.hide()
	moving = false
	
	var smoke_instance = load("res://Scenes/Useful/boss_smoke.tscn").instantiate()
	add_child(smoke_instance)
	smoke_instance.modulate.a = 0
	smoke_instance.rotation_degrees = 90 # Se rota para que encaje con el jefe
	smoke_instance.scale = Vector2(1.25,1.25)
	
	await Funcs.fade_effect(smoke_instance, true)
	await get_tree().create_timer(1.5, false).timeout
	
	sprite.show()
	collision.disabled = false
	
	await Funcs.fade_effect(smoke_instance, false)
	smoke_instance.queue_free()
	moving = true

func _physics_process(_delta):
	life_bar.set_current_value(life)
	
	dash_target_ray.rotation = Funcs.get_angle(player.global_position, global_position) + PI
	
	if moving and not is_in_group("Full_Freezed"): 
		manage_movement()
		if dash_target_pos.distance_to(global_position) < 2:
			dash_target_pos = dash_target.global_position
	
	# Ataque
	if can_attack:
		if Funcs.probability(50) and not dash_target_ray.get_collider() is TileMap:
			summon_eggs()
		else: teleport()
		
		can_attack = false
	
	# Controlar sprite
	if global_position.x < player.global_position.x:
		sprite.flip_h = true
		shoot_pos.position.x = -21
		collision.scale.x = -1
	else:
		sprite.flip_h = false
		shoot_pos.position.x = 21
		collision.scale.x = 1
	
	if player.life <= 0: get_node("Music").stop()

# Al disminuir la distancia entre el destino y la posicion, la velocidad se va reduciendo
func manage_movement() -> void:
	velocity = (dash_target_pos - global_position) * (speed / 50)

var can_attack := false
@onready var attack_timer := get_node("Attack_Timer")
func _on_attack_timer_timeout():
	can_attack = true
	attack_timer.start(randf_range(7, 10))


var egg := preload("res://Scenes/Enemies/DesertMother/desert_mother_egg.tscn")
@onready var particles_timer := get_node("Particles_Timer")
func summon_eggs():
	moving = false
	velocity = Vector2.ZERO # Para frenar; que se quede quieta al invocar el huevo
	await get_tree().create_timer(2, false).timeout
	
	moving = true
	dash_target_pos = dash_target.global_position # Reiniciar la posicion del dash por si el dash anterior estaba incompleto
	# Y para hacer un nuevo dash de generar huevos
	speed *= 1.5 # Aumentar velocidad para que quede mejor
	particles_timer.start() # Para generar particulas durante el dash
	
	for i in 3:
		if dash_target_ray.get_collider() is TileMap: continue
		
		var egg_instance := egg.instantiate()
		
		if Vars.main_scene.has_node("Enemies"):
			Vars.main_scene.get_node("Enemies").add_child(egg_instance)
			egg_instance.global_position = global_position
		else: egg_instance.queue_free()
		await get_tree().create_timer(0.25, false).timeout
	
	speed /= 1.5 # Devolver velocidad
	particles_timer.stop() # Apagar particulas

func _on_particles_timer_timeout():
	Funcs.smoke_effect(Vector2(2,2), global_position)

# Se teletransporta justo detras del jugador en diagonal a la direccion a la que se dirige
func teleport():
	moving = false
	velocity = Vector2.ZERO # Para frenar; que se quede quieta al invocar el huevo
	await Funcs.fade_effect(sprite, false, true)
	
	global_position += (player.global_position - global_position) * 1.6
	
	await Funcs.fade_effect(sprite, true, true)
	dash_target_pos = dash_target.global_position
	moving = true

# Este ataque lo va a estar haciendo continuamente
# No importa si can_attack esta en true o false
var stinger := preload("res://Scenes/Enemies/scorpion_stinger.tscn")
func shoot():
	for i in 6:
		var stinger_instance := stinger.instantiate()
		stinger_instance.damage += 5
		stinger_instance.scale = Vector2(1.5,1.5)
		
		if Funcs.add_to_bullets(stinger_instance):
			stinger_instance.global_position = shoot_pos.global_position
			stinger_instance.direction = (player.global_position - shoot_pos.global_position).normalized()
			stinger_instance.rotation = Funcs.get_angle(player.global_position, shoot_pos.global_position)
		else: stinger_instance.queue_free()
		await get_tree().create_timer(0.15, false).timeout


func _on_die():
	if Vars.main_scene.has_node("Music"):
		Vars.main_scene.get_node("Music").play()
	if life_bar != null: life_bar.queue_free()
	Funcs.color_explosion(3,3,global_position, Funcs.get_bullets_node(), 8, true, Color.html("#4e495f"))

@icon("res://Sprites/Player/PlayerNodeIcon.png")
extends CharacterBody2D
class_name Player

@export_group("Needed Nodes")
@export var damage_collision : Area2D
@export var sprite_perk : PackedScene

@export_group("Stats")

@export var original_speed = 110
var speed
signal modify_speed(normal_speed)

@export var max_life = 100
var life
var immune
var damaging
var enemies_attacking = []
@export var resistance = 0 
signal die

@export var max_energy = 200
var energy
@export var original_energy_recover_weight = 1.0
var energy_recover_weight
var can_use_energy
var fill_energy : bool

signal add_score(new_score)
var score

var perk_activated

var shoot_pos := Vector2(0,0)

signal toggle_dark_mode(activate : bool)

## Se usa para crear una funcion de physics process en la instancia
## sin sobreescribir el codigo de la clase
signal _extra_physics_process()

func _init():
	speed = original_speed
	
	immune = false
	
	can_use_energy = true
	fill_energy = true
	energy_recover_weight = original_energy_recover_weight
	
	score = 0
	
	perk_activated = false
	
	add_to_group("Player_Slime")

func _ready():
	life = max_life
	energy = max_energy
	damage_collision.add_to_group("Player_Slime")
	
	create_children()
	
	set_perk()
	
	connect_signals()

func _physics_process(_delta):
	_extra_physics_process.emit()
	
	var raw_velocity = Vector2(0,0)
	
	if Input.is_action_pressed("up"):
		raw_velocity.y -= 1
	if Input.is_action_pressed("down"):
		raw_velocity.y += 1
	if Input.is_action_pressed("left"):
		raw_velocity.x -= 1
	if Input.is_action_pressed("right"):
		raw_velocity.x += 1
	
	shoot_pos = get_global_mouse_position()
	
	velocity = raw_velocity.normalized() * speed
	
	velocity.x = lerp(velocity.x, 0.0, 0.5)
	velocity.y = lerp(velocity.y, 0.0, 0.5)
	
	## Todo lo que tenga que ver con energía ##
	if energy < max_energy && fill_energy:
		energy += energy_recover_weight
	
	if int(energy) <= 0:
		can_use_energy = false
	elif energy >= max_energy:
		can_use_energy = true
		energy = max_energy
	## Termina lo de energía ##
	
	if life > max_life: life = max_life
	
	if damaging && not immune:
		deal_damage_enemies()
	
	manage_perk()
	
	move_and_slide()

var perk_instance
func set_perk():
	perk_instance = sprite_perk.instantiate()
	add_child(perk_instance)
	perk_instance.z_index = 1
	perk_instance.position = Vector2(12, 62)

func connect_signals():
	get_node("Immunity_Cooldown").connect("timeout", _when_immunity_cooldown_timeout)
	get_node("Energy_Cooldown").connect("timeout", _when_energy_cooldown_timeout)
	connect("add_score", _when_add_score)
	connect("die", _when_die)
	connect("modify_speed", _when_modify_speed)
	connect("toggle_dark_mode", _toggle_dark_mode)
	connect_damage_collision()

func connect_damage_collision():
	damage_collision.connect("body_entered", _when_damage_collision_body_entered)
	damage_collision.connect("body_exited", _when_damage_collision_body_exited)
	damage_collision.connect("area_entered", _when_damage_collision_area_entered)
	damage_collision.connect("area_exited", _when_damage_collision_area_exited)

func create_children():
	add_child(load("res://Scenes/Player/dark_mode_rect.tscn").instantiate())
	
	if Vars.settings_data.show_FPS_counter:
		add_child(load("res://Scenes/Useful/fps_counter.tscn").instantiate())
	
	if Vars.hat_equipped != null:
		add_child(Vars.hat_equipped.instantiate())
	
	add_child(load("res://Scenes/Player/life_bar.tscn").instantiate())
	add_child(load("res://Scenes/Player/energy_bar.tscn").instantiate())
	
	immunity_cooldown = Timer.new()
	immunity_cooldown.wait_time = 1.0
	immunity_cooldown.name = "Immunity_Cooldown"
	add_child(immunity_cooldown)
	
	energy_cooldown = Timer.new()
	energy_cooldown.wait_time = 1.0
	energy_cooldown.name = "Energy_Cooldown"
	add_child(energy_cooldown)
	
	add_child(load("res://Scenes/Player/player_camera.tscn").instantiate())
	
	add_child(load("res://Scenes/Useful/weapon_module.tscn").instantiate())
	add_child(load("res://Scenes/Useful/abilities_module.tscn").instantiate())
	add_child(load("res://Scenes/Useful/passives_module.tscn").instantiate())
	
	score_text = load("res://Scenes/Player/score.tscn").instantiate()
	add_child(score_text)
	score_text.text = str(score)
	
	add_child(load("res://Scenes/Player/pause.tscn").instantiate())

func manage_perk():
	if perk_activated:
		perk_instance.self_modulate = Color(0.5, 0.5, 0.5)
		perk_instance.get_node("Energy_Use").hide()
	else:
		perk_instance.self_modulate = Color(1, 1, 1)
		perk_instance.get_node("Energy_Use").show()

var energy_cooldown : Timer
func reduce_energy(energy_to_reduce, fill_cooldown := 1.0) -> bool:
	if energy_to_reduce <= energy and can_use_energy and life > 0:
		energy -= energy_to_reduce
		energy_cooldown.start(fill_cooldown)
		fill_energy = false
		return true
	else: return false

var immunity_cooldown : Timer
func deal_damage_enemies():
	for enemy in enemies_attacking:
		life -= max(enemy.damage - resistance, 1)
		Funcs.sound_play("res://Sounds/SlimeHit.mp3", 0, 16)
		immunity_cooldown.start()
		immune = true
	if life <= 0: die.emit()

func deal_damage_special(damage, make_immune := true):
	life -= damage
	Funcs.sound_play("res://Sounds/SlimeHit.mp3", 0, 16)
	if make_immune: immunity_cooldown.start()
	if life <= 0: die.emit()

func _when_damage_collision_body_entered(body):
	# Cuando un enemigo toca al jugador esta función se ejecuta
	if body.is_in_group("Enemies"):
		enemies_attacking.append(body)
		damaging = true

func _when_damage_collision_body_exited(body):
	if body in enemies_attacking:
		enemies_attacking.erase(body)
		if len(enemies_attacking) == 0: damaging = false

func _when_damage_collision_area_entered(area):
	# Para proyectiles
	if area.is_in_group("Enemies") or area.is_in_group("Enemies_Projectiles"):
		enemies_attacking.append(area)
		damaging = true

func _when_damage_collision_area_exited(area):
	if area in enemies_attacking:
		enemies_attacking.erase(area)
		if len(enemies_attacking) == 0: damaging = false

func _when_modify_speed(new_speed):
	speed = new_speed

func _when_immunity_cooldown_timeout():
	immune = false

func _when_energy_cooldown_timeout():
	fill_energy = true

var score_text : Label
func _when_add_score(new_score):
	score += new_score
	score_text.text = str(score)

func _when_die():
	set_physics_process(false)
	Vars.last_score = score
	if Vars.map_state_data != null:
		if Vars.map_state_data.add_points_on_death:
			Vars.last_score += Vars.map_state_data.player_score
	
	preserve_dark_mode()
	
	hide()
	Funcs.regular_explosion(0.9, 0.9, global_position, Funcs.get_bullets_node(), 10, true)
	Vars.main_scene.get_node("Music").stop()
	await get_tree().create_timer(2.5).timeout
	Events.change_scene.emit("res://Scenes/Useful/dead_screen.tscn")

func _toggle_dark_mode(activate : bool):
	if activate:
		get_node("Dark_Mode_Rect").show()
	else:
		get_node("Dark_Mode_Rect").hide()

# Para que no desaparezca el dark mode luego de morir
func preserve_dark_mode():
	var dark_mode_rect = get_node("Dark_Mode_Rect")
	var pos = dark_mode_rect.global_position
	remove_child(dark_mode_rect)
	Vars.main_scene.get_node("Spawn_Position").add_child(dark_mode_rect)
	dark_mode_rect.global_position = pos

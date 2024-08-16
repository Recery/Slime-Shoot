@icon("res://Sprites/Enemies/EnemyNodeIcon.png")
extends CharacterBody2D
class_name Enemy

## El puntaje que se añade al jugador cuando mata a este enemigo
@export var score_to_add : int

@export_group("Stats")
@export var original_damage : float
var base_damage : float
var damage : float

@export var original_speed : float
var base_speed : float
var speed : float

@export var original_max_life : float
var base_max_life : float
var max_life : float
var life : float
var life_module
var immune := false # Si puede o no recibir daño

@export_group("Wait mode")
var nav_agent : NavigationAgent2D
## Si este enemigo espera a que el jugador se acerque para perseguirlo
@export var wait_player_mode = false
var waiting_player := true
## La distancia a la que puede detectar el enemigo al jugador
@export var distance_to_detect_player = 200

@onready var player = Vars.player

@onready var moving := true
# A veces, los enemigos tienen que moverse si o si independientemente de su estado
# Esta variable controla eso
@onready var force_moving := false
@export var use_pathfinding := true # Si es false, no usa el pathfinding
var dir := Vector2.ZERO
var go_backwards := false # SI esta en true, hace que vaya en sentido contrario al que indica la direccion

signal die
signal switch_wait_player(wait : bool)

# Constructor
var life_module_load = preload("res://Scenes/Useful/life_module.tscn")
func _init() -> void:
	life_module = life_module_load.instantiate()
	add_child(life_module)
	
	add_to_group("Enemies")
	
	connect("die", _when_die)
	connect("switch_wait_player", _on_switch_wait_player)
	connect("ready", _when_ready)
	
	visible = false

func _when_ready() -> void:
	waiting_player = wait_player_mode
	
	init_speed_values()
	init_damage_values()
	init_max_life()
	
	if use_pathfinding: init_pathfinding()
	init_shadows()

# Inicializar
func init_speed_values() -> void:
	if wait_player_mode:
		base_speed = original_speed + 6
		speed = original_speed + 6
	else:
		base_speed = original_speed
		speed = original_speed

func init_damage_values() -> void:
	if wait_player_mode:
		base_damage = original_damage * 2
		damage = original_damage * 2
	else:
		base_damage = original_damage
		damage = original_damage

func init_max_life() -> void:
	if wait_player_mode:
		base_max_life = original_max_life * 2
		max_life = original_max_life * 2
		life = max_life
	else:
		base_max_life = original_max_life
		max_life = original_max_life
		life = max_life
# Fin inicializar

func fill_life() -> void: life = max_life

@onready var already_emitted = false
func _when_die() -> void:
	if already_emitted: return
	already_emitted = true
	## En algunos casos, como la bomba, los enemigos pueden morir aún teniendo vida
	## En esos casos unicamente se añade puntaje si la vida es menor o igual a cero
	if life <= 0:
		player.add_score.emit(score_to_add)
		
	queue_free()

func init_pathfinding() -> void:
	nav_agent = load("res://Scenes/Enemies/pathfinding.tscn").instantiate()
	add_child(nav_agent)
	
	cooldown_pathfinding = Timer.new()
	cooldown_pathfinding.wait_time = 0.5
	cooldown_pathfinding.connect("timeout", cooldown_pathfinding_timeout)
	add_child(cooldown_pathfinding)
	cooldown_pathfinding.start()

func init_shadows() -> void:
	if not Vars.settings_data.shadows and has_node("Shadow"):
		get_node("Shadow").queue_free()

var custom_target_pos
func cooldown_pathfinding_timeout() -> void:
	cooldown_pathfinding.wait_time = max(global_position.distance_to(player.global_position) / 300, 0.5)
	if nav_agent != null:
		if custom_target_position_setted:
			nav_agent.target_position = custom_target_pos
		else:
			nav_agent.target_position = player.global_position
	
	if (moving and not is_in_group("Full_Freezed")) or force_moving:
		Funcs.pathfinding_movement(self, nav_agent)
	else: velocity = Vector2.ZERO

var cooldown_pathfinding : Timer
func force_pathfinding_update() -> void:
	if cooldown_pathfinding == null or nav_agent == null: return
	
	if cooldown_pathfinding.is_inside_tree() and nav_agent.is_inside_tree():
		cooldown_pathfinding_timeout()
		cooldown_pathfinding.start()

@onready var custom_target_position_setted = false
func set_custom_target_position(pos:Vector2, _force_movement = false) -> void:
	if nav_agent != null:
		custom_target_pos = pos
		custom_target_position_setted = true
		force_moving = _force_movement

func reset_custom_target_position(unforce_movement = true) -> void:
	custom_target_position_setted = false
	
	if unforce_movement:
		force_moving = false

func force_movement(force : bool) -> void: force_moving = force

func switch_pathfinding_cooldown(activate = true):
	if activate:
		cooldown_pathfinding.start()
	elif not activate:
		cooldown_pathfinding.stop()

func apply_new_speed() -> void:
	if (moving and not is_in_group("Full_Freezed")) or force_moving:
		if go_backwards: velocity = -dir * speed
		else: velocity = dir * speed
	else: velocity = Vector2.ZERO

func _on_switch_wait_player(wait := false) -> void:
	waiting_player = wait

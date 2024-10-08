extends CharacterBody2D
class_name Summon_Minion

## La distancia hasta la que puede escanear enemigos este minion
@export var scan_range = 100

## Valores para ajustar la posicion idle del minion.
## La X representa la distancia hasta la que el minion se acerca al jugador.
## La Y representa la distancia a la que el minion se empieza a mover lentamente alrededor del jugador.
@export var idle_pos_offset : Vector2

## La velocidad del minion siempre va a ser relativa a la del jugador.
## Esta variable define el factor por el que se multiplica la velocidad del jugador para obtener la velocidad del minion.
## Por ejemplo, velocidad = speed_weight * player.speed.
## Se ajusta automaticamente en idle_movement() y en ready.
## Debe ajustarse manualmente cuando se persigue un enemigo o en otras ocasiones que se desee.
@export var speed_weight = 0.5
var speed := 0

@export var scan_enemies := true # Si es false no escanea enemigos

var nav_agent : NavigationAgent2D
var dir := Vector2.ZERO

var targeted_enemy
var can_shoot

var idle_pos

var player

func _init():
	targeted_enemy = null
	ready.connect(_on_ready)

func _on_ready():
	player = Vars.player
	idle_pos = player.global_position
	create_children()

func create_children():
	if scan_enemies:
		var scan_timer := Timer.new()
		scan_timer.wait_time = 0.5
		scan_timer.autostart = true
		add_child(scan_timer)
		scan_timer.timeout.connect(scan_enemy_timeout)
	
	var pathfinding_timer = Timer.new()
	pathfinding_timer.wait_time = 0.4
	pathfinding_timer.autostart = true
	add_child(pathfinding_timer)
	pathfinding_timer.timeout.connect(pathfinding_timer_timeout)
	
	nav_agent = Funcs.get_nav_agent()
	add_child(nav_agent)

var acumulated_speed := 0
var move := true
var move_to_idle_pos := true
func idle_movement():
	speed = min(speed_weight * abs(player.speed), abs(player.speed) * 0.65)
	if global_position.distance_to(idle_pos) > idle_pos_offset.x: move_to_idle_pos = true
	elif global_position.distance_to(idle_pos) < idle_pos_offset.y: move_to_idle_pos = false
	
	if global_position.distance_to(player.global_position) > 200:
		global_position = player.global_position 
		targeted_enemy = null
	
	if targeted_enemy == null:
		if move_to_idle_pos:
			nav_agent.target_position = idle_pos
			move_to_pos(30)
		else:
			acumulated_speed += 1
			if acumulated_speed > (idle_pos_offset.x * idle_pos_offset.y) - 30: 
				move = not move
				acumulated_speed = 0
			
			if move: velocity = Vector2(8, 8)
			else: velocity = Vector2(-8, -8)
		move_and_slide()

func scan_enemy_timeout():
	targeted_enemy = Funcs.scan_for_enemy(scan_range, targeted_enemy, self)

func pathfinding_timer_timeout() -> void:
	dir = (nav_agent.get_next_path_position() - global_position).normalized()

func move_to_pos(speed_to_min : int) -> void:
	if dir != null:
		velocity = dir * (speed - speed_to_min)


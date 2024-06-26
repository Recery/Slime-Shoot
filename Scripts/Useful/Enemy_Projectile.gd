extends Area2D
## Un proyectil enemigo.
class_name Enemy_Projectile

@export_group("Stats")
@export var speed : int
@export var damage : float
## El tiempo que tardar en despawnear el proyectil.
## Si es menor o igual a cero, nunca despawnea.
@export_group("Other")
@export var despawn_time = 1.0
@export var has_movement = true

## Añade un tiempo extra de vida antes de morir el proyectil
@export var die_wait_time : float

var stop_working : bool
var direction : Vector2

## No hace falta añadir queue_free() ni poner en false stop_moving cuando se emite esta señal, ya lo hace en la clase original.
## Se debe emitir cuando se quiere eliminar el proyectil luego de cumplir su función.
signal die

func _init():
	stop_working = false
	connect("die", _when_die)
	connect("body_entered", _detect_tile_collision)
	connect("ready", _on_ready)
	add_to_group("Enemies_Projectiles")

func _on_ready():
	if despawn_time > 0:
		_set_despawn()

func _set_despawn():
	if not is_node_ready(): await ready
	
	var despawn_timer = Timer.new()
	add_child(despawn_timer)
	despawn_timer.start(despawn_time)
	await despawn_timer.timeout
	die.emit()

func _physics_process(delta):
	if not stop_working && has_movement:
		global_position += direction * speed * delta

func _when_die():
	if die_wait_time > 0: await get_tree().create_timer(die_wait_time).timeout
	stop_working = true
	queue_free()

func _detect_tile_collision(body):
	if not body is CharacterBody2D and has_movement: die.emit()

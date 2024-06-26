@tool
extends Area2D
class_name Friendly_Projectile

@export_group("Stats")
@export var speed : int
@export var original_damage : float
## El tiempo que tardar en despawnear el proyectil.
## Si es menor o igual a cero, nunca despawnea.
@export_group("Other")
## Si el despawn_time es 0, nunca despawnea (por tiempo)
@export var despawn_time = 1.0
@export var has_movement := true
## Si el proyectil es persistente, es decir que se usa siempre el mismo sin generar nuevos
## Hay una señal "reset_persistent" que sirve para reiniciar efectos del proyectil persistente
@export var persistent := false

## Añade un tiempo extra de vida antes de morir el proyectil
## El proyectil deja de funcionar luego de que pasa este tiempo
## (Es decir, se activa la variable stop_working al pasar ese tiempo)
@export var die_wait_time : float
## Que tipo de equipamiento genera este proyectil
@export_enum("Weapon", "Summon", "Ability") var generated_by = 0

## Llama a un metodo "_extra_physics_process()" para usarlo en herencias
## sin sobreescribir la clase base
@export var add_extra_physics_process := false

var stop_working : bool
var direction : Vector2

var damage : float

## No hace falta añadir queue_free() ni poner en false stop_moving cuando se emite esta señal, ya lo hace en la clase original.
## Se debe emitir cuando se quiere eliminar el proyectil luego de cumplir su función.
signal die
signal reset_persistent(proj)

func _init():
	if Engine.is_editor_hint():
		deactivate_process()
		return
	
	set_collision_layer_value(1, false)
	for i in range(4):
		if i == 0: set_collision_mask_value(i+1, false)
		else: set_collision_mask_value(i+1, true)
	
	stop_working = false
	connect("die", _when_die)
	connect("body_entered", _detect_tile_collision)
	connect("ready", _on_ready)
	add_to_group("Friendly_Damage")

func _on_ready():
	damage = original_damage
	if despawn_time > 0:
		_set_despawn()

func _set_despawn():
	if not is_node_ready(): await ready
	
	var despawn_timer := Timer.new()
	despawn_timer.wait_time = despawn_time
	add_child(despawn_timer)
	despawn_timer.start()
	await despawn_timer.timeout
	die.emit()

func deactivate_process():
	await ready
	set_physics_process(false)

func _physics_process(delta):
	if not stop_working && has_movement:
		global_position += direction * speed * delta
	if add_extra_physics_process: _extra_physics_process()

func _extra_physics_process(): pass

func _detect_tile_collision(body):
	if not body.is_in_group("Enemies") && has_movement: 
		die.emit()

func _when_die():
	if die_wait_time > 0: await get_tree().create_timer(die_wait_time).timeout
	stop_working = true
	queue_free()

func _ready():
	if not has_node("Is_Original") && Engine.is_editor_hint(): 
		set_script(null)

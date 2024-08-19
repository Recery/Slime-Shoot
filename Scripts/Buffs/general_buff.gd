## La base para hacer buffs
@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends Node
class_name General_Buff

## Cuanto dura el buff. Si es 0 o menos, es infinito.
## En caso de ser infinito, la clase que instancia el buff debería manejar cuando se remueve, simplemente usar queue_free() en ese caso
@export var duration := 0.0

## El color al que cambia el objeto que recibió el buff
@export var color : Color

## El objeto al que afecta este buff, normalmente el jugador o un enemigo, quien normalmente es el padre de este buff
var affected_object : Node

## Señal que se emite luego de reestablecer los valores que modifico este buff
## Obviamente se puede conectar esta señal a otros métodos para hacer algo si es necesario
signal buff_removed(buff)

func _init() -> void:
	# Se conecta el ready a otro metodo por si se quiere usar _ready en clases heredadas
	ready.connect(_on_ready)

func _on_ready() -> void:
	if affected_object == null:
		printerr("Error: Buff does not have a parent node to affect.")
		queue_free()
		return
	
	# Verifica algunas cosas para ver si el nodo que se libero era un buff adecuado para que este buff vuelva a aplicarse
	affected_object.child_entered_tree.connect(check_applicable)
	
	apply_color()
	
	set_timer()

### Setear temporizador para eliminar el buff (Si la duracion es mayor a 0) ###
var duration_timer : Timer
func set_timer():
	duration_timer = Timer.new()
	duration_timer.wait_time = duration
	add_child(duration_timer)
	duration_timer.timeout.connect(func(): queue_free())
	duration_timer.start()

func reset_duration(): if duration_timer != null: duration_timer.start()
### Fin parte timer ###

func check_applicable(node) -> void:
	if node == null: return
	
	if (is_instance_of(node, General_Buff) or node is Knockback) and node != self:
		node.buff_removed.connect(buff_application)

func apply_color() -> void:
	if color == Color(0, 0, 0, 1): return
	
	if affected_object.has_node("Slime"):
		affected_object.get_node("Slime").self_modulate = color
		if affected_object.has_node("Hat"):
			affected_object.get_node("Hat").self_modulate = color
	else:
		affected_object.modulate = color

func reset_color() -> void:
	if color == Color(0, 0, 0, 1): return
	
	if affected_object.has_node("Slime"):
		affected_object.get_node("Slime").self_modulate = Color(1,1,1)
		if affected_object.has_node("Hat"):
			affected_object.get_node("Hat").self_modulate = Color(1,1,1)
	else:
		affected_object.modulate = Color(1,1,1)

## Este metodo SIEMPRE recibe un objeto que es General_Buff (o Knockback)
func buff_application(_buff): pass

func remove_buff(): pass

func _exit_tree():
	await remove_buff()
	reset_color()
	buff_removed.emit(self)

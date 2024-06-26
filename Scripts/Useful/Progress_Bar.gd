extends Node2D

@export var max_value = 100.0
@export var min_value = 0.0
@export var current_value = 0.0
## Se puede conectar la barra a un timer para que se vaya modificando dependiendo del time left
@export var timer_connected: Timer
## Si se llena o se vacia dependiendo del time left del timer
@export var fill_with_timer = true

var rectangle_max_size

## Recibe un valor "value", ese valor se le suma al valor actual, no se reemplaza
signal update_value(value)

func _ready():
	rectangle_max_size = get_node("ColorRect").size.x
	connect("update_value", _on_update_value)
	
	if timer_connected != null:
		min_value = 0.0
		max_value = timer_connected.wait_time
		if fill_with_timer: set_current_value(min_value)
		else: set_current_value(max_value)
		set_process(true)
	else: set_process(false)

func _process(_delta):
	if fill_with_timer: set_current_value(timer_connected.wait_time - timer_connected.time_left)
	else: 
		set_current_value(timer_connected.time_left)

func set_current_value(value):
	current_value = value
	update_value.emit(0)

func set_color(color : Color):
	get_node("ColorRect").color = color

func _on_update_value(value:float):
	current_value += value
	var new_size = (current_value / max_value) * rectangle_max_size
	get_node("ColorRect").size.x = new_size

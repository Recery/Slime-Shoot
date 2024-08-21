extends Node
class_name Timered_Smoke

## Por cuanto tiempo genera humo. Si es 0 genera infinitamente
var duration : float
## Cuanto tarda en generar una instancia de humo
var time_to_create : float
## Tengo que explicarlo?
var smoke_scale

## Crea una instancia de humo por cada tiempo que se le especifica
func _init(dur, time, scale := Vector2(1,1)):
	duration = dur
	time_to_create = time
	smoke_scale = scale

func _ready():
	var smoke_timer := Timer.new()
	smoke_timer.wait_time = time_to_create
	smoke_timer.timeout.connect(create_smoke)
	add_child(smoke_timer)
	smoke_timer.start()
	
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		queue_free()

func create_smoke():
	if get_parent() == null: return
	Funcs.smoke_effect(smoke_scale, get_parent().global_position)

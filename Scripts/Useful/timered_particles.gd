extends Node
class_name Timered_Particles

## Por cuanto tiempo genera particulas. Si es 0 genera infinitamente
var duration : float
## Cuanto tarda en generar una instancia de particula
var time_to_create : float
## Tengo que explicarlo?
var particle_scale
## Color de las particulas
var particle_color : Color

## Crea una instancia de particula por cada tiempo que se le especifica
func _init(dur, time, color : Color, scale := Vector2(1,1)):
	duration = dur
	time_to_create = time
	particle_color = color
	particle_scale = scale

func _ready():
	var particle_timer := Timer.new()
	particle_timer.wait_time = time_to_create
	particle_timer.timeout.connect(create_particles)
	add_child(particle_timer)
	particle_timer.start()
	
	if duration > 0:
		await get_tree().create_timer(duration).timeout
		queue_free()

func create_particles():
	if get_parent() == null: return
	Funcs.particles(particle_scale, get_parent().global_position, particle_color)

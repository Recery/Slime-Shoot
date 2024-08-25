@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends Buff
class_name Buff_Life_Enemy

## La vida total que añade (o elimina) del enemigo
@export var life_to_add := 0.0

## La cantidad de iteraciones por la que añade una parte de la vida. Si es 1 añade todo inmediatamente
@export var iterations : int = 0


var life_per_iteration : float
func _ready():
	affected_object = get_parent()
	if not affected_object is Enemy:
		printerr("Error: The affected object of this life buff is not an enemy.")
		queue_free()
		return
	
	life_per_iteration = life_to_add / iterations
	buff_application(self)

func buff_application(buff):
	if buff != self: return # No importa si se añade otro buff de regeneracion/daño ya que este buff no reestablece valores al terminar
	
	if life_to_add < 0:
		reduce_life(duration / iterations)
	elif life_to_add > 0:
		add_life(duration / iterations)

func reduce_life(time_to_reduce):
	if time_to_reduce < 0.05: pass
	
	for i in range(iterations):
		await get_tree().create_timer(time_to_reduce).timeout
		Funcs.deal_damage(affected_object, -life_per_iteration)

func add_life(time_to_add):
	for i in range(iterations):
		await get_tree().create_timer(time_to_add).timeout
		Funcs.heal_enemy(affected_object, life_per_iteration)

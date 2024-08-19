extends Enemy

@onready var trap_sound := get_node("Trap_Sound")

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 2, true)

var energy_drain_trap := preload("res://Scenes/Enemies/Bootstrapper/energy_drain_trap.tscn")
func create_energy_drain_trap():
	trap_sound.play()
	
	var energy_drain_trap_instance := energy_drain_trap.instantiate()
	
	if Funcs.add_to_summons(energy_drain_trap_instance):
		energy_drain_trap_instance.global_position = global_position
	else: energy_drain_trap_instance.queue_free()

extends Ability

var lethal_vacuum_cleaner := preload("res://Scenes/Abilities/lethal_vacuum_cleaner.tscn")
func _on_activate() -> void:
	get_node("Use_Sound").play()
	var vacuum_instance := lethal_vacuum_cleaner.instantiate()
	if Funcs.add_to_summons(vacuum_instance):
		vacuum_instance.global_position = player.global_position
		player.summons_module.add_turret(vacuum_instance)
	else: vacuum_instance.queue_free()

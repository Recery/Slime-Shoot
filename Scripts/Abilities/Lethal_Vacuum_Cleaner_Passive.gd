extends Ability

var lethal_vacuum_cleaner = preload("res://Scenes/Abilities/lethal_vacuum_cleaner.tscn")

func _on_activate() -> void:
	get_node("Use_Sound").play()
	var vacuum_instance = lethal_vacuum_cleaner.instantiate()
	vacuum_instance.global_position = player.global_position
	Vars.main_scene.get_node("Summons").add_child(vacuum_instance)

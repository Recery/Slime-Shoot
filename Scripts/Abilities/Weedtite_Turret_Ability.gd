extends Ability

var turret = preload("res://Scenes/Abilities/weedtite_turret.tscn")
@onready var use_sound = get_node("Use_Sound")
func _on_activate() -> void:
	use_sound.play()
	var turret_instance = turret.instantiate()
	Vars.main_scene.get_node("Summons").add_child(turret_instance)
	turret_instance.global_position = player.global_position

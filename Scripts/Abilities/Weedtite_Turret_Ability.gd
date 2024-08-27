extends Ability

var turret = preload("res://Scenes/Abilities/weedtite_turret.tscn")
@onready var use_sound = get_node("Use_Sound")
func _on_activate() -> void:
	use_sound.play()
	var turret_instance = turret.instantiate()
	if Funcs.add_to_summons(turret_instance):
		turret_instance.global_position = player.global_position
		player.summons_module.add_turret(turret_instance)
	else: turret_instance.queue_free()

extends Ability

@onready var cheese := preload("res://Scenes/Abilities/cheese.tscn")

func _on_activate():
	Funcs.sound_play("res://Sounds/CheeseTransmutation.mp3", 6, 1.3)
	
	var enemy : Node = Funcs.scan_for_enemy(150, null, player)
	
	if enemy == null: return
	
	var i := 0
	var exceptions : Array[Node] = []
	while enemy.is_in_group("Big_Enemies") or enemy.is_in_group("Boss"):
		i += 1
		if i > 100: return
		exceptions.append(enemy)
		enemy = Funcs.scan_for_enemy(150, null, player, exceptions)
		if enemy == null: return
	
	var cheese_instance = cheese.instantiate()
	Vars.main_scene.get_node("Summons").add_child(cheese_instance)
	cheese_instance.global_position = enemy.global_position
	
	Funcs.particles(Vector2(2,2), enemy.global_position, Color.html("#ffd860"))
	player.add_score.emit(enemy.score_to_add)
	enemy.queue_free()

extends Camera2D

@onready var despawner := preload("res://Scenes/Useful/despawn.tscn")

func _on_enemy_enter_detecter_body_entered(body):
	if body.is_in_group("Enemies"):
		body.visible = true
		
		if body.has_node("Despawn"):
			body.get_node("Despawn").queue_free()

func _on_enemy_enter_detecter_body_exited(body):
	if body.is_in_group("Enemies"):
		body.visible = false
		
		if not body.is_in_group("Boss") and not body.wait_player_mode and not body.is_in_group("Cant_Despawn"): 
			body.add_child(despawner.instantiate())

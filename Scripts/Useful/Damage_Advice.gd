extends Node2D

var damage_text = preload("res://Scenes/Useful/damage_text.tscn")
func _on_deal_damage(enemy, damage):
	var damage_text_instance = damage_text.instantiate()
	damage_text.can_instantiate()
	
	if not Funcs.add_to_bullets(damage_text_instance): return
	damage_text_instance.global_position = Vector2(enemy.global_position.x, enemy.global_position.y - 10)
	var damage_label_text : String = str(damage).substr(0, str(damage).find(".") + 3)
	damage_text_instance.text = damage_label_text

extends Node2D

var damage_text = preload("res://Scenes/Useful/damage_text.tscn")
func _on_deal_damage(enemy, damage):
	if enemy.immune: return
	var damage_text_instance = damage_text.instantiate()
	
	if not Funcs.add_to_bullets(damage_text_instance): return
	damage_text_instance.global_position = Vector2(enemy.global_position.x, enemy.global_position.y - 10)
	var damage_label_text : String = str(damage).substr(0, str(damage).find(".") + 3)
	damage_text_instance.text = damage_label_text

var heal_text = preload("res://Scenes/Useful/heal_text.tscn")
func _on_heal(enemy, life):
	var life_text_instance = heal_text.instantiate()
	
	if not Funcs.add_to_bullets(life_text_instance): return
	life_text_instance.global_position = Vector2(enemy.global_position.x, enemy.global_position.y - 10)
	var life_label_text : String = str(life).substr(0, str(life).find(".") + 3)
	life_text_instance.text = life_label_text

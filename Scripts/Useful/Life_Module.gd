extends Node2D

@onready var enemy = get_parent()

signal take_damage(damage)
signal heal(heal_regen)

func _on_take_damage(damage):
	if enemy.immune or not is_instance_valid(enemy): return
	
	enemy.life -= damage
	Funcs.damage_advice._on_deal_damage(enemy, damage)
	if enemy.life <= 0: enemy.die.emit()

func _on_heal(heal_regen):
	if enemy.life + heal_regen < enemy.max_life:
		enemy.life += heal_regen
		Funcs.damage_advice._on_heal(enemy, heal_regen)
	else:
		Funcs.damage_advice._on_heal(enemy, enemy.max_life - enemy.life)
		enemy.life = enemy.max_life

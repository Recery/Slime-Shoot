extends Node2D

@onready var enemy = get_parent()

func take_damage(damage):
	if enemy.immune or not is_instance_valid(enemy): return
	
	enemy.life -= damage
	Funcs.damage_advice._on_deal_damage(enemy, damage)
	if enemy.life <= 0: enemy.die.emit()

func heal(heal_regen):
	if enemy.life + heal_regen < enemy.max_life:
		enemy.life += heal_regen
		Funcs.damage_advice._on_heal(enemy, heal_regen)
	else: enemy.life = enemy.max_life

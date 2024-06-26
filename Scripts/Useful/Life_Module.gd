extends Node2D

@onready var enemy = get_parent()

func take_damage(damage):
	if enemy.immune: return
	
	enemy.life -= damage
	
	if enemy.life <= 0: enemy.die.emit()

func heal(heal_regen):
	if enemy.life + heal_regen < enemy.max_life:
		enemy.life += heal_regen
	else: enemy.life = enemy.max_life

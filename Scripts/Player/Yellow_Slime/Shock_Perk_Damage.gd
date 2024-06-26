extends Node2D

var generated_by
var damage

func _ready():
	generated_by = 2
	
	damage = 2
	attack_enemy()

func attack_enemy():
	await get_tree().create_timer(0.05).timeout
	Funcs.deal_damage(get_parent(), damage)
	queue_free()

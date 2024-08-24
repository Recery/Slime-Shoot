extends Node2D

func _ready():
	Vars.player.add_score.connect(enemy_killed)

func enemy_killed(_points, enemy):
	if enemy == null: return
	add_spirit(enemy.global_position, max(enemy.damage / 4, 1))

var spirit := preload("res://Scenes/Passives/traitor_spirit.tscn")
func add_spirit(pos : Vector2, damage : float):
	var spirit_instance := spirit.instantiate()
	if await Funcs.add_to_bullets_deferred(spirit_instance, pos):
		if not spirit_instance.is_node_ready(): await spirit_instance.ready
		spirit_instance.damage = damage

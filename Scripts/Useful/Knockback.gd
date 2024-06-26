extends Node2D
class_name Knockback

var enemy : Enemy
var knockback_weight : int

func _init(weight = 200):
	knockback_weight = weight

func _ready():
	connect("tree_exiting", _on_tree_exiting)
	enemy = get_parent()
	enemy.speed = -knockback_weight
	enemy.force_movement(true)
	enemy.force_pathfinding_update()
	enemy.move_and_slide()
	queue_free()

func _on_tree_exiting():
	enemy.speed = enemy.base_speed
	enemy.force_movement(false)
	enemy.force_pathfinding_update()

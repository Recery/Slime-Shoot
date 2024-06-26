extends Node

var enemy : Enemy
var duration := 4.0

func _ready():
	add_to_group("Color_Debuff")
	
	enemy = get_parent()
	enemy.add_to_group("Full_Freezed")
	enemy.connect("child_exiting_tree", enemy_child_exiting_tree)
	enemy.modulate = Color(0.639, 0.757, 1)
	enemy.force_pathfinding_update()
	get_node("Duration").wait_time = duration
	get_node("Duration").start()

func _on_duration_timeout():
	if enemy == null: return
	enemy.modulate = Color(1, 1, 1)
	if enemy.is_in_group("Full_Freezed"):
		enemy.remove_from_group("Full_Freezed")
	enemy.force_pathfinding_update()
	queue_free()

func enemy_child_exiting_tree(child):
	if child == null or child == self: return
	if child.is_in_group("Color_Debuff"):
		enemy.modulate = Color(0.639, 0.757, 1)
	if not enemy.is_in_group("Full_Freezed"):
		enemy.add_to_group("Full_Freezed")
		enemy.force_pathfinding_update()

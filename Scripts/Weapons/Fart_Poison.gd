extends Node

var enemy
var exiting

const original_damage = 1
var damage

func _ready():
	damage = original_damage
	enemy = get_parent()
	enemy.modulate = Color(0, 0.973, 0)
	enemy.child_exiting_tree.connect(renew_color)
	exiting = false

func reset_timer(): get_node("Despawn_Timer").start()

func _on_damage_timer_timeout():
	if "life" in enemy:
		Funcs.deal_damage(enemy, damage)

func _on_despawn_timer_timeout():
	exiting = true
	enemy.modulate = Color(1,1,1)
	queue_free()

func renew_color(node):
	if node.is_in_group("Color_Debuff") && not exiting:
		enemy.modulate = Color(0, 0.973, 0)

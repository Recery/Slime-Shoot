extends Friendly_Projectile

func _ready():
	if direction.x < 0: get_node("Sprite2D").flip_v = true

func _on_body_entered(body):
	if not body.is_in_group("Player") && not stop_working:
		hide()
		if body.is_in_group("Enemies"):
			Funcs.deal_damage(body, damage)
			stop_working = true
			die.emit()

var puddle_generated := false
func _on_die():
	if puddle_generated: return
	puddle_generated = true
	var puddle : Node = load("res://Scenes/Weapons/paint_bomb_puddle.tscn").instantiate()
	Vars.main_scene.get_node("Summons").call_deferred("add_child", puddle)
	if not puddle.is_inside_tree(): await puddle.tree_entered
	puddle.global_position = global_position

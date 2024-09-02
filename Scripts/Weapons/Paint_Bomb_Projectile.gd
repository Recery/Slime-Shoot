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
var puddle := preload("res://Scenes/Weapons/paint_bomb_puddle.tscn")
func _on_die():
	if puddle_generated: return
	puddle_generated = true
	var puddle_instance := puddle.instantiate()
	if not await Funcs.add_to_summons_deferred(puddle_instance, global_position):
		puddle_instance.queue_free()

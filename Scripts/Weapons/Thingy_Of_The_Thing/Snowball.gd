extends Friendly_Projectile

var freeze_debuff = preload("res://Scenes/Weapons/freeze_debuff.tscn")

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or body == null: return
	var freeze_instance = freeze_debuff.instantiate()
	freeze_instance.duration = 1.5
	body.add_child(freeze_instance)
	
	if not stop_working: die.emit()

func _on_die():
	stop_working = true
	hide()
	get_node("CollisionShape2D").scale = Vector2(3,3)
	Funcs.color_explosion(1, 1, global_position, Funcs.get_bullets_node(), 2, true, Color.GHOST_WHITE)

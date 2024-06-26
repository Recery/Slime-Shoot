extends Friendly_Projectile

func _ready():
	get_node("Sprite2D").flip_v = direction.x < 0

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		hide()
		if body.is_in_group("Enemies") && !stop_working:
			Funcs.deal_damage(body, damage)
			die.emit()

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 4, true)

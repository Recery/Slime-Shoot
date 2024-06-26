extends Friendly_Projectile

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		if body.is_in_group("Enemies") && !stop_working:
			Funcs.deal_damage(body, damage)
			Funcs.dash_smoke(1, 1, global_position, 1, Funcs.get_bullets_node(), true)
			stop_working = true

func _on_animation_player_animation_finished(_anim_name):
	queue_free()

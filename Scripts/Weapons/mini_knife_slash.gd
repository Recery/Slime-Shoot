extends Friendly_Projectile

func _on_body_entered(body) -> void:
	if not body.is_in_group("Enemies") or stop_working: return
	
	Funcs.deal_damage(body, damage)
	Funcs.strike_effect(Vector2(1,1), global_position)
	stop_working = true

func _on_animation_player_animation_finished(_anim_name) -> void:
	queue_free()

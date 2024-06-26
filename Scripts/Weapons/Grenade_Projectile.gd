extends Friendly_Projectile

var exploding
var enemies_damaged

func _ready():
	exploding = false
	enemies_damaged = 0
	if direction.x < 0: get_node("Sprite2D").flip_v = true

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		hide()
		if body.is_in_group("Enemies") && !exploding:
			Funcs.deal_damage(body, damage)
			stop_working = true
			die.emit()
		elif body.is_in_group("Enemies") && enemies_damaged <= 5:
			# Fórmula para obtener el daño de area del proyectil, puede variar dependiendo de los buffs, y esta formula lo ajusta correctamente
			var area_damage := (damage / original_damage) * (original_damage - 4)
			Funcs.deal_damage(body, area_damage)
			enemies_damaged += 1

func _on_die():
	get_node("CollisionShape2D").scale = Vector2(6,6)
	exploding = true
	Funcs.regular_explosion(2.5, 2.5, global_position, Funcs.get_bullets_node(), 12, true)

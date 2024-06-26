extends Friendly_Projectile

var enemies_damaged

func _ready():
	enemies_damaged = 0
	remove_from_group("Friendly_Damage")

var fart_poison := preload("res://Scenes/Weapons/fart_poison.tscn")
func _on_body_entered(body):
	if !body.is_in_group("Player"):
		if body.is_in_group("Enemies") && enemies_damaged < 5:
			if body.has_node("Fart_Poison"):
				body.get_node("Fart_Poison").reset_timer()
			else:
				body.add_child(fart_poison.instantiate())
			enemies_damaged += 1
		if enemies_damaged >= 5: die.emit()

func _on_die():
	Funcs.color_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 0, false, Color(0,0.97,0))

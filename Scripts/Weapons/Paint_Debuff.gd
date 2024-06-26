extends Buff

var damage : int = 1
var original_damage : int = 1

func _on_damage_timer_timeout():
	Funcs.deal_damage(enemy, damage)

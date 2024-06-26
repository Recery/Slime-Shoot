extends Buff

func _ready():
	enemy.modulate = Color(0.6, 0.455, 0.361)
	
	add_to_group("coffee_debuff")

func _on_buff_removed():
	enemy.life = 0
	enemy.die.emit()

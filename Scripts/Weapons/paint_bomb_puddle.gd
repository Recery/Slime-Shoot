extends Friendly_Projectile

func _ready():
	Funcs.sound_play_2d("res://Sounds/Cake.mp3", global_position, 12, 1.4)
	
	match randi_range(0,3):
		0: modulate = Color.YELLOW
		1: modulate = Color.DEEP_SKY_BLUE
		2: modulate = Color.ORANGE
		3: modulate = Color.GREEN

func _on_body_entered(body) -> void:
	if not body.is_in_group("Enemies"): return
	
	var speed_debuff := get_speed_debuff()
	body.add_child(speed_debuff)
	body_exited.connect(speed_debuff.queue_free)
	
	var damage_debuff := get_deal_damage_debuff()
	body.add_child(damage_debuff)
	body_exited.connect(damage_debuff.queue_free)

func _on_body_exited(body) -> void:
	if not body.is_in_group("Enemies"): return
	

func get_speed_debuff() -> Buff_Speed_Enemy:
	var debuff := Buff_Speed_Enemy.new()
	debuff.duration = 6
	debuff.weight_to_modify = 0.45
	return debuff

func get_deal_damage_debuff() -> Buff_Life_Enemy:
	var debuff := Buff_Life_Enemy.new()
	debuff.duration = 6
	debuff.life_to_add = -4
	debuff.iterations = 4
	return debuff

func _on_die():
	monitoring = false
	Funcs.fade_effect(self)

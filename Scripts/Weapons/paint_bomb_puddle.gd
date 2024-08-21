extends Friendly_Projectile

var debuffs : Array[Node]
func _ready():
	Funcs.sound_play_2d("res://Sounds/Cake.mp3", global_position, 12, 1.4)
	
	match randi_range(0,3):
		0: modulate = Color.YELLOW
		1: modulate = Color.DEEP_SKY_BLUE
		2: modulate = Color.ORANGE
		3: modulate = Color.GREEN

func _on_body_entered(body) -> void:
	if not body.is_in_group("Enemies"): return
	
	body.add_child(get_speed_debuff())
	body.add_child(get_deal_damage_debuff())

func _on_body_exited(body) -> void:
	if not body.is_in_group("Enemies"): return
	
	for child in body.get_children():
		if child.is_in_group(name): child.free_buff()

func get_speed_debuff() -> Buff_Speed_Enemy:
	var debuff := Buff_Speed_Enemy.new()
	debuff.duration = 6
	debuff.weight_to_modify = 0.45
	debuff.add_to_group(name)
	debuffs.append(debuff)
	return debuff

func get_deal_damage_debuff() -> Buff_Life_Enemy:
	var debuff := Buff_Life_Enemy.new()
	debuff.duration = 6
	debuff.life_to_add = -4
	debuff.iterations = 4
	debuff.add_to_group(name)
	debuffs.append(debuff)
	return debuff

func _on_die():
	monitoring = false
	
	for d in debuffs:
		if d != null: d.free_buff()
	
	Funcs.fade_effect(self)

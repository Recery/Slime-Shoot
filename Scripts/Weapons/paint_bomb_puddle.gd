extends Friendly_Projectile

@onready var debuff := preload("res://Scenes/Weapons/paint_debuff.tscn")
var debuffs : Array

func _ready():
	Funcs.sound_play_2d("res://Sounds/Cake.mp3", global_position, 12, 1.4)
	
	match randi_range(0,3):
		0: modulate = Color.YELLOW
		1: modulate = Color.DEEP_SKY_BLUE
		2: modulate = Color.ORANGE
		3: modulate = Color.GREEN

func _on_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		var debuff_instance := debuff.instantiate()
		debuffs.append(debuff_instance)
		body.add_child(debuff_instance)

func _on_body_exited(body) -> void:
	if body.is_in_group("Enemies"):
		for node in body.get_children():
			if debuffs.has(node) and node is Buff:
				debuffs.erase(node)
				node.remove_debuff()
				break

func _on_die():
	monitoring = false
	
	for node in debuffs:
		if node != null and node is Buff:
			node.remove_debuff()
	Funcs.fade_effect(self)

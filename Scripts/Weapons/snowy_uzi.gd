extends Weapon

@onready var cannon := get_node("Cannon")
@onready var shoot_sound := get_node("Shoot_Sound")
@onready var bullet := preload("res://Scenes/Weapons/weedtite_bullet.tscn")

func _on_shoot():
	shoot_sound.play()
	if flip_v: cannon.position.y = 2
	else: cannon.position.y = -2
	
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = Funcs.get_angle(player.shoot_pos, cannon.global_position)
	bullet_instance.direction = (player.shoot_pos - cannon.global_position).normalized()
	if not Funcs.add_to_bullets(bullet_instance): return
	
	bullet_instance.global_position = cannon.global_position

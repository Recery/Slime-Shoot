extends Weapon

@onready var paint_bomb = preload("res://Scenes/Weapons/paint_bomb_projectile.tscn")
@onready var recharge_visual := get_node("Recharge_Visual")

func _on_shoot() -> void:
	modulate.a = 0
	recharge_visual.start()
	Funcs.sound_play("res://Sounds/Throw.mp3", 8, 1)
	
	var bomb_instance = paint_bomb.instantiate()
	
	bomb_instance.rotation = Funcs.get_angle(get_global_mouse_position(), global_position)
	bomb_instance.direction = (get_global_mouse_position() - global_position).normalized()
	if not Funcs.add_to_bullets(bomb_instance): return
	bomb_instance.global_position = global_position

func _on_recharge_visual_timeout():
	Funcs.dash_smoke(1,1, global_position, 1, self)
	modulate.a = 1

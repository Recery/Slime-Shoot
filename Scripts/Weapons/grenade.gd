extends Weapon

@onready var projectile := preload("res://Scenes/Weapons/grenade_projectile.tscn")
@onready var recharge_visual := get_node("Recharge_Visual")
@onready var throw_sound := get_node("Throw_Sound")

func _on_shoot():
	recharge_visual.start()
	throw_sound.play()
	modulate.a = 0
	
	var projectile_instance = projectile.instantiate()
	projectile_instance.direction = (get_global_mouse_position() - global_position).normalized()
	projectile_instance.rotation = Funcs.get_angle(get_global_mouse_position(), global_position)
	
	if not Funcs.add_to_bullets(projectile_instance): return
	projectile_instance.global_position = global_position

func _on_recharge_visual_timeout():
	Funcs.dash_smoke(1,1, global_position, 1, self)
	modulate.a = 1

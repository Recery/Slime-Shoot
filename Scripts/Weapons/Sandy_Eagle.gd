extends Weapon

@onready var cannon := get_node("Cannon")
@onready var shoot_sound := get_node("Shoot_Sound")
@onready var fire : AnimatedSprite2D = get_node("Fire_Effect")
@onready var bullet = preload("res://Scenes/Weapons/sandy_bullet.tscn")
func _on_shoot():
	shoot_sound.play()
	fire.visible = true
	fire.play("Fire")
	
	if flip_v: 
		cannon.position.y = 2.527
		fire.position.y = 1.5
	else: 
		cannon.position.y = -2.527
		fire.position.y = -1.5
	
	var bullet_instance = bullet.instantiate()
	bullet_instance.rotation = Funcs.get_angle(get_global_mouse_position(), cannon.global_position)
	bullet_instance.direction = (get_global_mouse_position() - cannon.global_position).normalized()
	if not Funcs.add_to_bullets(bullet_instance): return
	
	bullet_instance.global_position = cannon.global_position

func _on_fire_effect_animation_finished():
	fire.visible = false

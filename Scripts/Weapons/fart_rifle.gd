extends Weapon

@onready var cannon := get_node("Cannon")
@onready var shoot_sound := get_node("Shoot_Sound")
@onready var fart := preload("res://Scenes/Weapons/fart.tscn")
func _on_shoot() -> void:
	shoot_sound.play()
	if flip_v: cannon.position.y = 1.5
	else: cannon.position.y = -1.5
	
	var fart_instance = fart.instantiate()
	fart_instance.rotation = Funcs.get_angle(get_global_mouse_position(), cannon.global_position)
	fart_instance.direction = (get_global_mouse_position() - cannon.global_position).normalized()
	if not Funcs.add_to_bullets(fart_instance): return
	
	fart_instance.global_position = cannon.global_position

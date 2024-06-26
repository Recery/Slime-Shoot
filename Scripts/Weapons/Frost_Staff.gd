extends Weapon

@onready var light_shoot := get_node("Light_Shoot")
func _extra_process():
	if flip_v: 
		light_shoot.position.y = 3
	else: 
		light_shoot.position.y = -3

@onready var spike := preload("res://Scenes/Weapons/frost_spike.tscn")
@onready var shoot_sound := get_node("Shoot_Sound")
@onready var anim_player := get_node("AnimationPlayer")
func _on_shoot() -> void:
	shoot_sound.play()
	anim_player.current_animation = "shoot"
	light_shoot.enabled = true
	
	var frost_spike_instance := spike.instantiate()
	frost_spike_instance.direction = (get_global_mouse_position() - global_position).normalized()
	frost_spike_instance.rotation = Funcs.get_angle(get_global_mouse_position(), global_position)
	if not Funcs.add_to_bullets(frost_spike_instance): return
	
	frost_spike_instance.global_position = light_shoot.global_position

func _on_animation_player_animation_finished(_anim_name):
	light_shoot.enabled = false

extends Weapon

var shooting := false

var slash := preload("res://Scenes/Garden/Equipment/scythe_slash.tscn")

func _extra_process():
	if shooting: use_rotation()

@onready var slash_pos := get_node("Slash_Pos")
func _on_shoot():
	Funcs.sound_play("res://Sounds/Knife.mp3", 9, 0.9)
	var slash_instance := slash.instantiate()
	if flip_v: 
		slash_instance.scale = Vector2(-2.5,-2.5)
		slash_instance.rotation = rotation - PI
	else: slash_instance.rotation = rotation
	Funcs.add_to_bullets_deferred(slash_instance, slash_pos.global_position)
	shooting = true

func use_rotation():
	var original_rotation := rotation
	if flip_v: rotation_degrees = rad_to_deg(original_rotation) - 45
	else: rotation_degrees = rad_to_deg(original_rotation) + 45
	await get_tree().create_timer(0.2).timeout
	rotation = original_rotation
	shooting = false

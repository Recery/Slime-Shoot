extends Weapon

var shooting := false

func _extra_process():
	if shooting: slash_rotation()

@onready var slash_pos := get_node("Slash_Pos")
@onready var wood_sound := get_node("Wood_Sound")
@onready var slash := preload("res://Scenes/Weapons/baby_log_slash.tscn")
func _on_shoot():
	shooting = true
	wood_sound.play()
	var slash_instance = slash.instantiate()
	slash_pos.add_child(slash_instance)
	slash_instance.position = slash_pos.position
	slash_instance.position.x -= 4

func slash_rotation():
	if flip_v: rotation_degrees = rotation_degrees - 35
	else: rotation_degrees = rotation_degrees + 35
	await get_tree().create_timer(0.05).timeout
	if flip_v: rotation_degrees = rotation_degrees - 35
	else: rotation_degrees = rotation_degrees + 35
	await get_tree().create_timer(0.05).timeout
	shooting = false

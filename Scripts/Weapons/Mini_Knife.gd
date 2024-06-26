extends Weapon

var shooting := false

func _extra_process():
	if shooting: slash_rotation()

@onready var slash := preload("res://Scenes/Weapons/mini_knife_slash.tscn")
@onready var slash_pos = get_node("Slash_Pos")
func _on_shoot():
	Funcs.sound_play("res://Sounds/Knife.mp3", 9, 1.1)
	shooting = true
	var slash_instance = slash.instantiate()
	slash_pos.add_child(slash_instance)
	slash_instance.position = slash_pos.position
	slash_instance.position.x -= 4

func slash_rotation():
	var original_rotation = rotation
	if flip_v: rotation_degrees = rad_to_deg(original_rotation) - 30
	else: rotation_degrees = rad_to_deg(original_rotation) + 30
	await get_tree().create_timer(0.1).timeout
	rotation = original_rotation
	shooting = false

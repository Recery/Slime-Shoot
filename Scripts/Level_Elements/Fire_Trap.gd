@tool
extends Sprite2D

@export_enum("Up", "Down", "Left", "Right") var direction := 0

func _process(_delta) -> void:
	if not Engine.is_editor_hint():
		set_process(false)
	else:
		match direction:
			0: rotation_degrees = 0
			1: rotation_degrees = 180
			2: rotation_degrees = -90
			3: rotation_degrees = 90

var fireball := preload("res://Scenes/Enemies/fireball.tscn")
@onready var shoot_pos := get_node("Shoot_Pos")
func shoot():
	if Vars.player != null:
		if Vars.player.global_position.distance_to(global_position) > 200:
			return
	
	var fireball_dir := Vector2.ZERO
	var fireball_rot := 0 # Cuanto rota en grados la bola de fuego
	
	match direction:
		0: 
			fireball_dir = Vector2(0, -1)
			fireball_rot = 180
		1: 
			fireball_dir = Vector2(0, 1)
			fireball_rot = 0
		2: 
			fireball_dir = Vector2(-1, 0)
			fireball_rot = 90
		3: 
			fireball_dir = Vector2(1, 0)
			fireball_rot = -90
	
	var fireball_instance : Enemy_Projectile = fireball.instantiate()
	fireball_instance.direction = fireball_dir
	fireball_instance.rotation_degrees = fireball_rot
	
	if Funcs.add_to_bullets(fireball_instance):
		fireball_instance.damage = 15
		fireball_instance.global_position = shoot_pos.global_position
	else: fireball_instance.queue_free()

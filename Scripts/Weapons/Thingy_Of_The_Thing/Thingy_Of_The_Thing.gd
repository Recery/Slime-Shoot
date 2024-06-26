extends Weapon

# Determina tipo de proyectil que va a disparar
var current_projectile := 0

func _ready():
	current_projectile = randi_range(0,2)
	get_node("Frame_Sprite").visible = false
	switch_sprite()

var bombucha = preload("res://Scenes/Weapons/Thingy_Of_The_Thing/bombucha.tscn")
var snowball = preload("res://Scenes/Weapons/Thingy_Of_The_Thing/snowball.tscn")
var vampiric_knife = preload("res://Scenes/Weapons/Thingy_Of_The_Thing/vampiric_knife.tscn")

@onready var recharge_visual = get_node("Recharge_Visual")
func _on_shoot():
	match current_projectile:
		0:
			var bombucha_instance = bombucha.instantiate()
			add_to_bullets_node(bombucha_instance)
			bombucha_instance.set_frame(bombucha_frame)
		1:
			var snowball_instance = snowball.instantiate()
			add_to_bullets_node(snowball_instance)
		2:
			var vampiric_instance = vampiric_knife.instantiate()
			add_to_bullets_node(vampiric_instance)
	
	Funcs.sound_play_2d("res://Sounds/Throw.mp3", 8, 1)
	current_projectile = randi_range(0,2)
	recharge_visual.start(shoot_cooldown)
	
	switch_sprite()
	modulate.a = 0

func add_to_bullets_node(proj : Node2D) -> void:
	proj.rotation = Funcs.get_angle(get_global_mouse_position(), global_position)
	proj.direction = (get_global_mouse_position() - global_position).normalized()
	if not Funcs.add_to_bullets(proj): return
	proj.global_position = global_position

var bombucha_frame := 0
func switch_sprite():
	match current_projectile:
		0:
			texture = load("res://Sprites/Weapons/ThingyOfTheThing/Bombucha.png")
			hframes = 5
			frame = randi_range(0,4)
			bombucha_frame = frame
		1:
			texture = load("res://Sprites/Weapons/ThingyOfTheThing/Snowball.png")
			frame = 0
			hframes = 1
		2:
			texture = load("res://Sprites/Weapons/ThingyOfTheThing/VampiricKnife.png")
			frame = 0
			hframes = 1

func _on_recharge_visual_timeout():
	Funcs.dash_smoke(1,1, global_position, 1, self)
	modulate.a = 1

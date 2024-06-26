extends Weapon

@onready var cannon = get_node("Frame_Sprite/Cannon")
@onready var pistol = get_node("Frame_Sprite")

@onready var idle_sound = get_node("Idle_Sound")
@onready var shoot_sound = get_node("Shoot_Sound")

# El sprite de la mochila, va separado para que rote con el arma
var backpack : Sprite2D
var water : Node2D

# sound_init_mode controla que se inicie el audio idle 
# solo una vez cuando se tiene el arma en mano
var sound_init_mode := true

func _ready() -> void:
	backpack = load("res://Scenes/Weapons/pressure_washer_backpack.tscn").instantiate()
	player.add_child(backpack)
	if player.has_node("Weapon_Module"):
		player.move_child(backpack, player.get_node("Weapon_Module").get_index())
	
	water = load("res://Scenes/Weapons/pressure_washer_shot.tscn").instantiate()
	water.cannon = cannon
	water.pistol = self
	if not Funcs.add_to_bullets(water): return

func _physics_process(_delta) -> void:
	if not active:
		hide()
		backpack.hide()
		if idle_sound.playing: idle_sound.stop()
		sound_init_mode = true
		return
	else:
		backpack.show()
		if sound_init_mode:
			switch_sound(true)
			sound_init_mode = false
		show()
	
	if Input.is_action_pressed("shoot") && can_shoot:
		if player.reduce_energy(energy_use, energy_recover_cooldown): shoot.emit()
	
	Funcs.weapon_rotation(self, hold_offset)
	
	pistol.flip_v = flip_v
	if flip_v:
		cannon.position.y = 1.5
	else:
		cannon.position.y = -1.5

func _on_shoot() -> void:
	water.monitoring = true
	water.visible = true
	water_hide_cooldown.start()
	
	switch_sound(false)

@onready var water_hide_cooldown = get_node("Hide_Water_Cooldown")
func _on_hide_water_cooldown_timeout() -> void:
	water.monitoring = false
	water.visible = false
	
	switch_sound(true)

func switch_sound(play_idle : bool) -> void:
	if play_idle:
		if idle_sound.playing: return
		idle_sound.playing = true
		shoot_sound.playing = false
	else:
		if shoot_sound.playing: return
		idle_sound.playing = false
		shoot_sound.playing = true

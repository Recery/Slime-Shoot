extends Weapon

func _ready():
	player.toggle_dark_mode.connect(_on_player_dark_mode)

@onready var glass_1 := get_node("Glass_1")
@onready var glass_2 := get_node("Glass_2")
@onready var square_1 := get_node("Glass_1/Square")
@onready var square_2 := get_node("Glass_2/Square")

func _physics_process(_delta):
	if not active:
		visible = false
		player.energy_recover_weight = player.original_energy_recover_weight
		return
	else:
		visible = true
		player.energy_recover_weight = player.original_energy_recover_weight + 0.3
		player.can_use_energy = true
	
	if Input.is_action_pressed("shoot") && can_shoot:
		if player.reduce_energy(energy_use, energy_recover_cooldown): shoot.emit()
	
	if flip_v: 
		light_1.position.y = -2.5
		light_2.position.y = -2.5
		glass_1.position.y = -6
		glass_2.position.y = -6
		square_1.position.y = 6
		square_2.position.y = 6
	else:
		light_1.position.y = 2.5
		light_2.position.y = 2.5
		glass_1.position.y = 0
		glass_2.position.y = 0
		square_1.position.y = -1
		square_2.position.y = -1
	
	Funcs.weapon_rotation(self, hold_offset)

var switch := false
@onready var light_1 := get_node("Light")
@onready var light_2 := get_node("Light2")
func animate_light():
	light_1.visible = switch
	light_2.visible = not switch
	
	switch = not switch

func _on_shoot():
	var life_to_reduce : int = player.max_life * 0.25
	player.deal_damage_special(life_to_reduce)
	get_node("Sound").play()
	player.energy = player.max_energy
	
	var use_light = get_node("Use_Light")
	if flip_v: use_light.position.y = -2.5
	else: use_light.position.y = 2.5
	use_light.show()
	await get_tree().create_timer(0.15).timeout
	use_light.hide()

func _on_player_dark_mode(activate : bool):
	if activate:
		light_1.scale = Vector2(4.5,4.5)
		light_1.energy = 1
		light_2.scale = Vector2(4,4)
		light_2.energy = 1
	else:
		light_1.scale = Vector2(1,1)
		light_1.energy = 0.2
		light_2.scale = Vector2(1.2,1.2)
		light_2.energy = 0.2

extends Node2D

@onready var weapon_frame = get_node("Current_Weapon_Frame")
@onready var swap_cooldown = get_node("Swap_Cooldown")

var weapons := []
var cooldowns = []
var size_equipped

var current_weapon
var draw_weapon : Node

var can_swap

func _ready():
	# Esto obtiene cuantas armas tiene equipadas el jugador
	# Luego carga cuántas posiciones tiene el array dependiendo de lo equipado
	# El máximo es 3, pero puede llegar a tener 2 o 1
	size_equipped = 0
	for i in range(Vars.weapons_equipped.size()):
		if Vars.weapons_equipped[i] != null: size_equipped += 1
	weapons.resize(size_equipped)
	cooldowns.resize(size_equipped)
	
	# Cargar armas elegidas en el array de weapons
	# Inicializar posición de las armas y añadirlas al módulo
	# Conectar las señales de disparo de cada arma a este módulo
	# Si el slot de arma equipada no contiene nada, no se la añade al array
	# Si el slot tiene un arma, se suma 1 a la variable de control de total_equipped
	# Esta variable determina cuantas armas se equiparon y sirve para acceder
	# a la posición del próximo arma a cargar
	var total_equipped = 0
	for i in range(Vars.weapons_equipped.size()):
		if Vars.weapons_equipped[i] != null && total_equipped < weapons.size():
			weapons[total_equipped] = Vars.weapons_equipped[i].instantiate()
			weapons[total_equipped].position = position
			add_child(weapons[total_equipped])
			cooldowns[total_equipped] = get_node("Cooldown_" + str(total_equipped+1))
			if weapons[total_equipped].shoot_cooldown > 0:
				cooldowns[total_equipped].wait_time = weapons[total_equipped].shoot_cooldown
			weapons[total_equipped].shoot.connect(_on_shoot)
			total_equipped += 1
	
	# El arma de la posición 0 es la primera en aparecer
	current_weapon = 0
	weapons[current_weapon].active = true
	can_swap = true
	draw_current_weapon()

func _input(event):
	if event.is_action_pressed("swap_weapon_up") && can_swap:
		current_weapon += 1
		if current_weapon >= size_equipped: current_weapon = 0
		
		for i in range(weapons.size()): weapons[i].active = false
		weapons[current_weapon].active = true
		
		draw_current_weapon()
		
		swap_cooldown.start()
		can_swap = false
	elif event.is_action_pressed("swap_weapon_down") && can_swap:
		current_weapon -= 1
		if current_weapon < 0: current_weapon = size_equipped - 1
		
		for weapon in weapons: weapon.active = false
		weapons[current_weapon].active = true
		
		draw_current_weapon()
		
		swap_cooldown.start()
		can_swap = false

func _on_shoot():
	weapon_frame.modulate = Color(0.5,0.5,0.5)
	# Si el arma tiene cooldown 0 solo nos interesa oscurecer el recuadro
	if weapons[current_weapon].shoot_cooldown <= 0: 
		cooldowns[current_weapon].start(0.05)
		return
	weapons[current_weapon].can_shoot = false
	cooldowns[current_weapon].start()

func _on_cooldown_1_timeout():
	cooldown_timeout(0)

func _on_cooldown_2_timeout():
	cooldown_timeout(1)

func _on_cooldown_3_timeout():
	cooldown_timeout(2)

func _on_swap_cooldown_timeout():
	swap_cooldown.stop()
	can_swap = true

func cooldown_timeout(slot):
	weapons[slot].can_shoot = true
	cooldowns[slot].stop()
	if cooldowns[current_weapon] == cooldowns[slot]:
		weapon_frame.modulate = Color(1,1,1)

func draw_current_weapon():
	if draw_weapon != null: draw_weapon.queue_free()
	
	if weapons[current_weapon].has_node("Frame_Sprite"):
		draw_weapon = weapons[current_weapon].get_node("Frame_Sprite").duplicate()
	else: draw_weapon = weapons[current_weapon].duplicate()
	
	for child in draw_weapon.get_children():
		if child is PointLight2D: child.queue_free()
	draw_weapon.set_script(null)
	add_child(draw_weapon)
	draw_weapon.visible = true
	draw_weapon.modulate.a = 1
	draw_weapon.rotation = 0
	draw_weapon.flip_v = false
	draw_weapon.z_index = 1
	draw_weapon.global_position = weapon_frame.global_position
	if cooldowns[current_weapon].time_left == 0: weapon_frame.modulate = Color(1,1,1)
	else: weapon_frame.modulate = Color(0.5,0.5,0.5)

extends Node2D

var abilities := []
var cooldowns := []
var first_cooldown := []
var size_equipped

var player

func _ready():
	player = Vars.player
	
	# Ver "weapons_module", ya que funciona de manera muy parecida a este
	size_equipped = 0
	for ability in SaveSystem.get_curr_file().save_equipment.equipped_abilities:
		if ability != null: size_equipped += 1
	abilities.resize(size_equipped)
	cooldowns.resize(size_equipped)
	first_cooldown.resize(size_equipped)
	
	var total_equipped = 0
	for ability in SaveSystem.get_curr_file().save_equipment.equipped_abilities:
		if ability != null and total_equipped < abilities.size():
			abilities[total_equipped] = ability.instantiate()
			abilities[total_equipped].position = get_node("Pos_" + str(total_equipped+1)).position
			add_child(abilities[total_equipped])
			abilities[total_equipped].get_node("Cooldown_Left").show()
			abilities[total_equipped].modify_cooldown.connect(modify_cooldown)
			cooldowns[total_equipped] = get_node("Cooldown_" + str(total_equipped+1))
			cooldowns[total_equipped].wait_time = abilities[total_equipped].starter_cooldown
			cooldowns[total_equipped].start()
			first_cooldown[total_equipped] = true
			total_equipped += 1

func _process(_delta) -> void:
	for i in range(abilities.size()):
		if cooldowns[i].time_left != 0:
			abilities[i].get_node("Cooldown_Left").text = str(int(cooldowns[i].time_left)+1)
			abilities[i].get_node("Ability_Frame").self_modulate = Color(0.5, 0.5, 0.5)
			abilities[i].get_node("Energy_Use").hide()

func _input(event) -> void:
	if abilities.size() == 0: return
	for i in range(abilities.size()):
		if event.is_action_pressed("ability_" + str(i+1)):
			try_to_activate(i)

func try_to_activate(slot) -> void:
	if slot < 0 or slot >= abilities.size(): return
	# La variable can_use verifica si la habilidad está en cooldown o no
	# El método can_be_activated devuelve true si el jugador tiene suficiente
	# energía para usar la habilidad, en caso contrario devuelve false
	if !abilities[slot].can_use or !abilities[slot].can_be_activated(): return
	abilities[slot].activate.emit()
	abilities[slot].can_use = false
	abilities[slot].get_node("Cooldown_Left").show()
	abilities[slot].get_node("Energy_Use").hide()
	cooldowns[slot].start()

func cooldown_timeout(slot):
	abilities[slot].can_use = true
	abilities[slot].get_node("Ability_Frame").self_modulate = Color(1, 1, 1)
	abilities[slot].get_node("Cooldown_Left").hide()
	abilities[slot].get_node("Energy_Use").show()
	cooldowns[slot].stop()
	if first_cooldown[slot]:
		cooldowns[slot].wait_time = abilities[slot].cooldown
		first_cooldown[slot] = false

func _on_cooldown_1_timeout():
	cooldown_timeout(0)

func _on_cooldown_2_timeout():
	cooldown_timeout(1)

func _on_cooldown_3_timeout():
	cooldown_timeout(2)

# Algunas habilidades pueden solicitar cambiar su cooldown
func modify_cooldown(emitter, amount):
	for i in range(abilities.size()):
		if abilities[i] == emitter:
			cooldowns[i].wait_time = amount
			cooldowns[i].start()
			break

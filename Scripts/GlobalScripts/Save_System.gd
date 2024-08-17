extends Node

var path_weapons_equipped := "user://Weapons_Equipped.save"
var path_weapons_unlocked := "user://Weapons_Unlocked.save"
var path_abilities_equipped := "user://Abilities_Equipped.save"
var path_abilities_unlocked := "user://Abilities_Unlocked.save"
var path_passives_equipped := "user://Passives_Equipped.save"
var path_passives_unlocked := "user://Passives_Unlocked.save"
var path_slime_equipped := "user://Slime_Equipped.save"
var path_slimes_unlocked := "user://Slimes_Unlocked.save"
var path_hat_equipped := "user://Hat_Equipped.save"
var path_hats_unlocked := "user://Hats_Unlocked.save"
var path_pet_equipped := "user://Pet_Equipped.save"
var path_pets_unlocked := "user://Pets_Unlocked.save"

var path_points := "user://Points.save"
var path_settings := "user://SettingData.tres"
var path_cinematics := "user://Cinematics.save"

func _init():
	load_equipped_weapons()
	load_unlocked_weapons()
	load_equipped_abilities()
	load_unlocked_abilities()
	load_equipped_passives()
	load_unlocked_passives()
	load_equipped_slime()
	load_unlocked_slimes()
	load_equipped_hat()
	load_unlocked_hats()
	load_equipped_pet()
	load_unlocked_pets()
	load_total_points()
	load_settings()
	load_played_cinematics()

# Armas equipadas
func load_equipped_weapons():
	if !FileAccess.file_exists(path_weapons_equipped): 
		Vars.weapons_equipped[0] = load("res://Scenes/Weapons/weedtite_microgun.tscn")
		return
	
	var file = FileAccess.open(path_weapons_equipped, FileAccess.READ)
	for i in range(Vars.weapons_equipped.size()):
		var weapon_path = file.get_var()
		if weapon_path != null:
			Vars.weapons_equipped[i] = load(weapon_path)

func save_equipped_weapons():
	var file = FileAccess.open(path_weapons_equipped, FileAccess.WRITE)
	for i in range(Vars.weapons_equipped.size()):
		if Vars.weapons_equipped[i] != null:
			file.store_var(Vars.weapons_equipped[i].get_path())
		else: file.store_var(Vars.weapons_equipped[i])
# Fin armas equipadas

# Armas desbloqueadas
func load_unlocked_weapons():
	# Siempre carga la pistola basica al iniciar el juego
	# Es el arma por defecto
	Vars.weapons_unlocked[0] = load("res://Scenes/Weapons/weedtite_microgun.tscn")
	
	if !FileAccess.file_exists(path_weapons_unlocked): 
		return
	
	var file = FileAccess.open(path_weapons_unlocked, FileAccess.READ)
	while file.get_position() < file.get_length():
		var weapon_path = file.get_var()
		if weapon_path != null:
			Vars.weapons_unlocked.append(load(weapon_path))

func save_unlocked_weapons():
	var file = FileAccess.open(path_weapons_unlocked, FileAccess.WRITE)
	for i in range(Vars.weapons_unlocked.size()):
		if Vars.weapons_unlocked[i] != null && Vars.weapons_unlocked[i].get_path() != ("res://Scenes/Weapons/weedtite_microgun.tscn"):
			file.store_var(Vars.weapons_unlocked[i].get_path())
# Fin armas desbloqueadas

# Habilidades equipadas
func load_equipped_abilities():
	if !FileAccess.file_exists(path_abilities_equipped): return
	var file = FileAccess.open(path_abilities_equipped, FileAccess.READ)
	for i in range(Vars.abilities_equipped.size()):
		var ability_path = file.get_var()
		if ability_path != null:
			Vars.abilities_equipped[i] = load(ability_path)

func save_equipped_abilities():
	var file = FileAccess.open(path_abilities_equipped, FileAccess.WRITE)
	for i in range(Vars.abilities_equipped.size()):
		if Vars.abilities_equipped[i] != null:
			file.store_var(Vars.abilities_equipped[i].get_path())
		else: file.store_var(Vars.abilities_equipped[i])
# Fin habilidades equipadas

# Habilidades desbloqueadas
func load_unlocked_abilities():
	if !FileAccess.file_exists(path_abilities_unlocked): return
	var file = FileAccess.open(path_abilities_unlocked, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var ability_path = file.get_var()
		if ability_path != null:
			Vars.abilities_unlocked.append(load(ability_path))

func save_unlocked_abilities():
	var file = FileAccess.open(path_abilities_unlocked, FileAccess.WRITE)
	for i in range(Vars.abilities_unlocked.size()):
		file.store_var(Vars.abilities_unlocked[i].get_path())
# Fin habilidades desbloqueadas

# Pasivas equipadas
func load_equipped_passives():
	if !FileAccess.file_exists(path_passives_equipped): return
	var file = FileAccess.open(path_passives_equipped, FileAccess.READ)
	for i in range(Vars.passives_equipped.size()):
		var passive_path = file.get_var()
		if passive_path != null:
			Vars.passives_equipped[i] = load(passive_path)

func save_equipped_passives():
	var file = FileAccess.open(path_passives_equipped, FileAccess.WRITE)
	for i in range(Vars.passives_equipped.size()):
		if Vars.passives_equipped[i] != null:
			file.store_var(Vars.passives_equipped[i].get_path())
		else: file.store_var(Vars.passives_equipped[i])
# Fin pasivas equipadas

# Pasivas desbloqueadas
func load_unlocked_passives():
	if !FileAccess.file_exists(path_passives_unlocked): return
	var file = FileAccess.open(path_passives_unlocked, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var passive_path = file.get_var()
		if passive_path != null:
			Vars.passives_unlocked.append(load(passive_path))

func save_unlocked_passives():
	var file = FileAccess.open(path_passives_unlocked, FileAccess.WRITE)
	for i in range(Vars.passives_unlocked.size()):
		file.store_var(Vars.passives_unlocked[i].get_path())
# Fin pasivas desbloqueadas

# Slime equipado
func load_equipped_slime():
	if !FileAccess.file_exists(path_slime_equipped): 
		Vars.slime_equipped = load("res://Scenes/Player/Green_Slime/green_slime.tscn")
		return
	
	var file = FileAccess.open(path_slime_equipped, FileAccess.READ)
	var slime_path = file.get_var()
	if slime_path != null:
		Vars.slime_equipped = load(slime_path)

func save_equipped_slime():
	var file = FileAccess.open(path_slime_equipped, FileAccess.WRITE)
	if Vars.slime_equipped != null:
		file.store_var(Vars.slime_equipped.get_path())
# Fin slime equipado

# Slimes desbloqueados
func load_unlocked_slimes():
	# Siempre carga el slime verde primero
	# es el slime por defecto
	Vars.slimes_unlocked[0] = load("res://Scenes/Player/Green_Slime/green_slime.tscn")
	
	if !FileAccess.file_exists(path_slimes_unlocked): return
	
	var file = FileAccess.open(path_slimes_unlocked, FileAccess.READ)
	while file.get_position() < file.get_length():
		var slime_path = file.get_var()
		if slime_path != null:
			Vars.slimes_unlocked.append(load(slime_path))

func save_unlocked_slimes():
	var file = FileAccess.open(path_slimes_unlocked, FileAccess.WRITE)
	for i in range(Vars.slimes_unlocked.size()):
		file.store_var(Vars.slimes_unlocked[i].get_path())
# Fin slimes desbloqueados

# Sombrero equipado
func load_equipped_hat():
	if !FileAccess.file_exists(path_hat_equipped):
		return
	
	var file = FileAccess.open(path_hat_equipped, FileAccess.READ)
	var hat_path = file.get_var()
	if hat_path != null:
		Vars.hat_equipped = load(hat_path)
	else: Vars.hat_equipped = null

func save_equipped_hat():
	var file = FileAccess.open(path_hat_equipped, FileAccess.WRITE)
	if Vars.hat_equipped != null:
		file.store_var(Vars.hat_equipped.get_path())
	else: file.store_var(null)
# Fin sombrero equipado

# Sombreros desbloqueados
func load_unlocked_hats():
	if !FileAccess.file_exists(path_hats_unlocked): return
	
	var file = FileAccess.open(path_hats_unlocked, FileAccess.READ)
	while file.get_position() < file.get_length():
		var hat_path = file.get_var()
		if hat_path != null:
			Vars.hats_unlocked.append(load(hat_path))

func save_unlocked_hats():
	var file = FileAccess.open(path_hats_unlocked, FileAccess.WRITE)
	for i in range(Vars.hats_unlocked.size()):
		file.store_var(Vars.hats_unlocked[i].get_path())
# Fin sombreros desbloqueados

# Mascota equipada
func load_equipped_pet():
	if !FileAccess.file_exists(path_pet_equipped):
		return
	
	var file = FileAccess.open(path_pet_equipped, FileAccess.READ)
	var pet_path = file.get_var()
	if pet_path != null:
		Vars.pet_equipped = load(pet_path)
	else: Vars.pet_equipped = null

func save_equipped_pet():
	var file = FileAccess.open(path_pet_equipped, FileAccess.WRITE)
	if Vars.pet_equipped != null:
		file.store_var(Vars.pet_equipped.get_path())
	else: file.store_var(null)
# Fin mascota equipada

# Mascotas desbloqueadas
func load_unlocked_pets():
	if !FileAccess.file_exists(path_pets_unlocked): return
	
	var file = FileAccess.open(path_pets_unlocked, FileAccess.READ)
	while file.get_position() < file.get_length():
		var pet_path = file.get_var()
		if pet_path != null:
			Vars.pets_unlocked.append(load(pet_path))

func save_unlocked_pets():
	var file = FileAccess.open(path_pets_unlocked, FileAccess.WRITE)
	for i in range(Vars.pets_unlocked.size()):
		file.store_var(Vars.pets_unlocked[i].get_path())
# Fin mascotas desbloqueadas

# Puntos acumulados
func load_total_points():
	if !FileAccess.file_exists(path_points): return
	var file = FileAccess.open(path_points, FileAccess.READ)
	Vars.total_points = file.get_var()

func save_total_points():
	var file = FileAccess.open(path_points, FileAccess.WRITE)
	file.store_var(Vars.total_points)
# Fin puntos acumulados

# Ajustes
func load_settings():
	if not FileAccess.file_exists(path_settings):
		Vars.settings_data = SettingsData.new()
		save_settings()
		return
	Vars.settings_data = load(path_settings)

func save_settings():
	ResourceSaver.save(Vars.settings_data, path_settings)
# Fin ajustes

# Cinemáticas
func load_played_cinematics():
	if not FileAccess.file_exists(path_cinematics): return
	
	var file = FileAccess.open(path_cinematics, FileAccess.READ)
	while file.get_position() < file.get_length():
		var id_cinematic = file.get_var()
		if id_cinematic != null:
			Vars.cinematics_played.append(id_cinematic)

func save_played_cinematics():
	var file = FileAccess.open(path_cinematics, FileAccess.WRITE)
	for id in Vars.cinematics_played:
		file.store_var(id)
# Fin cinemáticas

# Para guardar el estado de un mapa
func save_map_state(map:Node):
	var map_state_data = MapStateData.new()
	
	for child in Funcs.get_all_children(map):
		if child.is_in_group("Enemy_Spawner"):
			map_state_data.spawners_level.append(child.spawner_level)
	
	if Vars.player != null:
		map_state_data.player_score = Vars.player.score
	
	map_state_data.has_progress_bar = map.has_progress_bar
	
	Vars.map_state_data = map_state_data

func load_map_state(map:Node):
	var children := Funcs.get_all_children(map)
	for i in range(children.size()):
		if children[i].is_in_group("Enemy_Spawner"):
			children[i].level_loaded_by_state = true
			children[i].spawner_level = Vars.map_state_data.assign_spawner_level(i)
	
	if Vars.player != null:
		Vars.player.score = Vars.map_state_data.player_score
		Vars.player.add_score.emit(0)
	
	if "has_progress_bar" in map:
		map.has_progress_bar = Vars.map_state_data.has_progress_bar

func reset_map_state():
	Vars.map_state_data = MapStateData.new()

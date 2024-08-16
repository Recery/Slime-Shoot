extends Node

var damage_advice : Node
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	damage_advice = load("res://Scenes/Useful/damage_advice.tscn").instantiate()
	add_child(damage_advice)

# Devuelve true o false dependiendo del número que se le envía. Por ejemplo, con un 30 tiene un 30% de devolver true.
func probability(percentage: float, max_value := 100.0) -> bool:
	return randf_range(0.0, max_value) < percentage

func sound_play(path: String, volume: float = 0, pitch: float = 0):
	var new_sound = AudioStreamPlayer.new()
	new_sound.volume_db += volume
	if pitch != 0: new_sound.pitch_scale = pitch
	new_sound.bus = "Sounds"
	new_sound.stream = load(path)
	
	var audio_finished = func():
		new_sound.queue_free()
	var entered = func():
		new_sound.play()
	
	new_sound.connect("finished", audio_finished)
	new_sound.connect("tree_entered", entered)
	if Vars.main_scene != null:
		Vars.main_scene.add_child.call_deferred(new_sound)

func sound_play_2d(path: String, pos : Vector2, volume: float = 0, pitch: float = 0):
	var new_sound = AudioStreamPlayer2D.new()
	new_sound.volume_db += volume
	if pitch != 0: new_sound.pitch_scale = pitch
	new_sound.bus = "Sounds"
	new_sound.stream = load(path)
	
	var audio_finished = func():
		new_sound.queue_free()
	var entered = func():
		new_sound.global_position = pos
		new_sound.play()
	
	new_sound.connect("finished", audio_finished)
	new_sound.connect("tree_entered", entered)
	if Vars.main_scene != null:
		Vars.main_scene.add_child.call_deferred(new_sound)

func get_angle(dest_pos, source_pos):
	return atan2(dest_pos.y - source_pos.y, dest_pos.x - source_pos.x)

func basic_movement(enemy, player):
	if enemy == null or player == null: return
	var dir_to_player = (enemy.global_position - player.global_position).normalized()
	enemy.velocity = -(dir_to_player * enemy.speed)

func pathfinding_movement(enemy : Enemy, nav_agent : NavigationAgent2D) -> void:
	if not enemy.is_node_ready(): return
	if nav_agent == null or enemy == null: return
	
	if not enemy.waiting_player:
		enemy.dir = (nav_agent.get_next_path_position() - enemy.global_position).normalized()
		if enemy.go_backwards:
			enemy.velocity = -enemy.dir * enemy.speed
		else:
			enemy.velocity = enemy.dir * enemy.speed
		return
	else: enemy.velocity = Vector2.ZERO
	
	if enemy.waiting_player:
		if enemy.distance_to_detect_player > enemy.global_position.distance_to(Vars.player.global_position):
			enemy.waiting_player = false
		elif enemy.life < enemy.base_max_life:
			enemy.waiting_player = false

func scan_for_enemy(scan_range:int, current_target, caller, exceptions = []):
	if current_target != null: return current_target
	var total_enemies = get_tree().get_nodes_in_group("Enemies")
	var in_range_enemies = []
	for i in range(total_enemies.size()):
		if total_enemies[i].global_position.distance_to(caller.global_position) < scan_range && not exceptions.has(total_enemies[i]):
			in_range_enemies.append(total_enemies[i])
	
	var nearest_enemy
	for i in range(in_range_enemies.size()):
		if i == 0: nearest_enemy = in_range_enemies[i]
		elif in_range_enemies[i].global_position.distance_to(caller.global_position) < nearest_enemy.global_position.distance_to(caller.global_position):
			nearest_enemy = in_range_enemies[i]
	
	return nearest_enemy

## Si el rango de escaneo es 0, se escanea en toda el area
func scan_farthest_enemy(scan_range:int, current_target, caller:Node, exceptions = []):
	if current_target != null: return current_target
	
	var total_enemies := get_tree().get_nodes_in_group("Enemies")
	for exception in exceptions:
		remove_array_elements(total_enemies, exception)
	
	var in_range_enemies = []
	if scan_range > 0: for enemy in total_enemies:
		if enemy.global_position.distance_to(caller.global_position) < scan_range:
			in_range_enemies.append(enemy)
	
	var farthest_enemy : Node = null
	if scan_range > 0: for i in range(in_range_enemies.size()):
		if i == 0: farthest_enemy = in_range_enemies[i]
		elif in_range_enemies[i].global_position.distance_to(caller.global_position) > farthest_enemy.global_position.distance_to(caller.global_position):
			farthest_enemy = in_range_enemies[i]
	else: for i in range(total_enemies.size()):
		if i == 0: farthest_enemy = total_enemies[i]
		elif total_enemies[i].global_position.distance_to(caller.global_position) > farthest_enemy.global_position.distance_to(caller.global_position):
			farthest_enemy = total_enemies[i]
	
	return farthest_enemy

func weapon_rotation(weapon, offset = Vector2(7,0), player = Vars.player, extra_angle := 0):
	var angle = rad_to_deg(get_angle(player.shoot_pos, weapon.global_position))
	
	weapon.rotation_degrees = angle
	
	if player == null: return
	if player.get_viewport() == null or get_viewport() == null: return
	
	var local_mouse_pos : Vector2 = player.to_local(player.shoot_pos)
	if local_mouse_pos.x < 0:
		weapon.global_position.x = player.global_position.x - offset.x
	else:
		weapon.global_position.x = player.global_position.x + offset.x
	
	weapon.flip_v = angle > 90 or angle < -90
	if weapon.flip_v: weapon.rotation_degrees -= extra_angle
	else: weapon.rotation_degrees += extra_angle
	
	weapon.global_position.y = player.global_position.y + offset.y

# Para reproducir una explosión normal
var explosion = preload("res://Scenes/Useful/explosion.tscn")
func regular_explosion(scale_x, scale_y, pos, scene, extra_sound, play_sound):
	if scene == null: return
	
	var explosion_instance = explosion.instantiate()
	var sound_instance = explosion_instance.get_node("Sound")
	if play_sound:
		sound_instance.volume_db += extra_sound
	else:
		sound_instance.volume_db = -10000
	
	scene.add_child(explosion_instance)
	explosion_instance.global_position = pos
	explosion_instance.scale = Vector2(scale_x, scale_y)

# Para reproducir una explosión con color
var col_explosion = preload("res://Scenes/Useful/color_explosion.tscn")
func color_explosion(scale_x, scale_y, pos, scene, extra_sound, play_sound, color : Color):
	if scene == null: return
	
	var explosion_instance = col_explosion.instantiate()
	var sound_instance = explosion_instance.get_node("Sound")
	if play_sound:
		sound_instance.volume_db += extra_sound
		sound_instance.global_position = pos
	else:
		sound_instance.volume_db = -10000
	
	scene.add_child(explosion_instance)
	explosion_instance.global_position = pos
	explosion_instance.scale = Vector2(scale_x, scale_y)
	explosion_instance.modulate = color

var smoke = preload("res://Scenes/Useful/smoke_dash.tscn")
func dash_smoke(scale_x, scale_y, pos, modulate = 0.75, scene = get_bullets_node(), insta_vanish = false):
	if scene == null: return
	
	var smoke_instance = smoke.instantiate()
	smoke_instance.scale = Vector2(scale_x, scale_y)
	smoke_instance.modulate.a = modulate
	smoke_instance.insta_vanish = insta_vanish
	scene.add_child(smoke_instance)
	smoke_instance.global_position = pos

var _particles = preload("res://Scenes/Useful/particles.tscn")
func particles(scale, pos, color : Color, scene = get_bullets_node()):
	if scene == null: return
	
	var particles_instance = _particles.instantiate()
	particles_instance.scale = scale
	particles_instance.modulate = color
	scene.add_child(particles_instance)
	particles_instance.global_position = pos

func timed_particles(scale : Vector2, time : float, color : Color, parent : Node) -> void:
	for i in range(int(time * 2)):
		if parent == null: return
		particles(scale, parent.global_position, color, parent)
		await get_tree().create_timer(0.5).timeout

func explosion_warning(scale : Vector2, pos : Vector2) -> Sprite2D:
	var warning_instance := Sprite2D.new()
	if Funcs.add_to_bullets(warning_instance):
		warning_instance.texture = load("res://Sprites/Useful/Explosion.png")
		warning_instance.hframes = 4
		warning_instance.frame = 3
		warning_instance.global_position = pos
		warning_instance.scale = scale
		warning_instance.modulate = Color.html("#ff5b4a4a")
	
	return warning_instance

func fade_effect(sprite, reversed = false, fast = false):
	if sprite == null: return
	
	var weight_to_add : float
	var weight_to_iterate : int
	
	if fast:
		weight_to_add = 0.1
		weight_to_iterate = 10
	else:
		weight_to_add = 0.05
		weight_to_iterate = 20
	
	if not reversed:
		for i in weight_to_iterate:
			if sprite == null: return
			sprite.modulate.a -= weight_to_add
			await get_tree().create_timer(0.08).timeout
	else:
		for i in weight_to_iterate:
			if sprite == null: return
			sprite.modulate.a += weight_to_add
			await get_tree().create_timer(0.08).timeout

func deal_damage(enemy, damage) -> void:
	if enemy == null: return
	
	if enemy.has_node("Life_Module"):
		enemy.get_node("Life_Module").take_damage.emit(damage)

func get_current_cooldown(weapon : Weapon) -> float:
	if Vars.player == null or weapon == null: return -1
	if not Vars.player.has_node("Weapon_Module"): return -1
	
	var weapons_module := Vars.player.get_node("Weapon_Module")
	var slot := 0
	
	for i in range(weapons_module.weapons.size()):
		if weapons_module.weapons[i] == weapon:
			slot = i
	return weapons_module.cooldowns[slot].wait_time

func get_cooldown_timeleft(weapon : Weapon) -> float:
	if Vars.player == null or weapon == null: return -1
	if not Vars.player.has_node("Weapon_Module"): return -1
	
	var weapons_module := Vars.player.get_node("Weapon_Module")
	var slot := 0
	
	for i in range(weapons_module.weapons.size()):
		if weapons_module.weapons[i] == weapon:
			slot = i
	return weapons_module.cooldowns[slot].time_left

func add_to_bullets(node : Node) -> bool:
	if node == null or Vars.main_scene == null: return false
	
	if Vars.main_scene.has_node("Bullets"):
		Vars.main_scene.get_node("Bullets").add_child(node)
		return true
	else: return false

func get_bullets_node() -> Node:
	if Vars.main_scene == null: return Node2D.new()
	
	if Vars.main_scene.has_node("Bullets"):
		return Vars.main_scene.get_node("Bullets")
	return Node2D.new()

func add_to_enemies(enemy : Enemy) -> bool:
	if enemy == null or Vars.main_scene == null: return false
	
	if Vars.main_scene.has_node("Enemies"):
		Vars.main_scene.get_node("Enemies").add_child(enemy)
		return true
	else: return false

func add_to_summons(node : Node) -> bool:
	if node == null or Vars.main_scene == null: return false
	
	if Vars.main_scene.has_node("Summons"):
		Vars.main_scene.get_node("Summons").add_child(node)
		return true
	else: return false

# Recibe una instancia de nodo y lo devuelve sin script
func set_non_script(instance : Node):
	instance.set_script(null)
	return instance

func has_node_in_group(node : Node, group : String) -> bool:
	if node == null: return false
	
	for child in node.get_children():
		if child.is_in_group(group): return true
	
	return false

func get_all_children(node) -> Array:
	var children := []
	if node == null: return []
	for child in node.get_children():
		if child.get_child_count() > 0:
			children.append(child)
			children.append_array(get_all_children(child))
		else: children.append(child)
	
	return children

func remove_children(parent:Node):
	if parent == null: return
	for child in parent.get_children():
		if child.get_parent() == parent:
			parent.call_deferred("remove_child", child)
			child.queue_free()

func remove_direct_children(parent:Node) -> void:
	if parent == null: return
	for child in parent.get_children():
		child.queue_free()

func get_safe_index(array : Array, index : int, default_value = null):
	if index >= 0 && index < array.size():
		return array[index]
	else: return default_value

func remove_array_elements(array : Array, element):
	var i := 0
	while i < array.size():
		if array[i] == element:
			array.remove_at(i)
		else:
			i += 1

## Solo crea una instancia del slime equipado junto al sombrero, y le saca el script para usarlo como dibujo
func draw_equipped_slime(with_shadow := true, scale := Vector2(1,1)) -> Node:
	var slime_draw := Vars.slime_equipped.instantiate()
	slime_draw.set_script(null)
	if slime_draw.has_node("Shadow") and not with_shadow:
		slime_draw.get_node("Shadow").modulate.a = 0
	
	if Vars.hat_equipped != null:
		var hat_draw := Vars.hat_equipped.instantiate()
		hat_draw.set_script(null)
		slime_draw.add_child(hat_draw)
	
	slime_draw.scale = scale
	return slime_draw

## Solo crea una instancia de la mascota equipada, y le saca el script para usarlo como dibujo
func draw_pet(with_shadow := true, scale := Vector2(1,1)) -> Node:
	if Vars.pet_equipped == null: return null
	
	var pet_draw = Vars.pet_equipped.instantiate()
	pet_draw.set_script(null)
	
	if pet_draw.has_node("Shadow") and not with_shadow:
		pet_draw.get_node("Shadow").modulate.a = 0
	elif pet_draw.has_node("Dynamic_Shadow") and not with_shadow:
		pet_draw.get_node("Dynamic_Shadow").modulate.a = 0
	
	pet_draw.scale = scale
	
	return pet_draw

# Pantalla completa
func _input(event):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != 3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

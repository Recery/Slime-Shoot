extends Sprite2D

@onready var head = get_node("Head")
@onready var aspire = get_node("Head/Aspire")
@onready var aspire_sound = get_node("Aspire_Sound")

var affected_enemies : Array[Node] = []

func _physics_process(_delta):
	var nearest_enemy
	for enemy in affected_enemies:
		if enemy != null:
			if nearest_enemy == null: nearest_enemy = enemy
			else:
				if global_position.distance_to(enemy.global_position) < global_position.distance_to(nearest_enemy.global_position):
					nearest_enemy = enemy
	
	if nearest_enemy == null: 
		aspire.visible = false
		return
	
	if not aspire_sound.playing: aspire_sound.play()
	aspire.visible = true
	head.rotation = Funcs.get_angle(nearest_enemy.global_position, global_position)

func _on_scan_enemies_timeout():
	var exceptions : Array[Node] = []
	# Los enemigos afectados son excepciones que no se escanean ya que,
	# justamente, ya fueron escaneados
	for enemy in affected_enemies:
		if enemy != null: exceptions.append(enemy)
	
	for i in range(10):
		var enemy = Funcs.scan_for_enemy(120, null, self, exceptions)
		
		if enemy != null:
			if enemy.is_in_group("Boss") or enemy.has_node("Vacuum_Buff"):
				exceptions.append(enemy)
			else:
				affected_enemies.append(enemy)
				enemy.set_custom_target_position(global_position, true)
				enemy.add_child(get_vacuum_debuff(enemy))
				enemy.force_pathfinding_update()
				# Solo hay que escanear 1 enemigo, se corta el bucle al encontrarlo
				# Se escanea 10 veces por si se escanean varios enemigos que no sirven
				break
	
	get_node("Enemy_Detecter").monitoring = true

var aspired_weight = 0
@onready var mini_progress_bar = get_node("Mini_Progress_Bar")
func _on_enemy_detecter_body_entered(body) -> void:
	
	if affected_enemies.has(body) and aspired_weight < 5:
		if body.is_in_group("Big_Enemies"): aspired_weight += 3
		else: aspired_weight += 1
		mini_progress_bar.set_current_value(mini_progress_bar.max_value - aspired_weight)
		body.life = 0
		body.die.emit()
	
	if aspired_weight >= 5:
		for enemy in affected_enemies:
			if enemy != null:
				enemy.reset_custom_target_position()
				if enemy.has_node("Vacuum_Buff"):
					enemy.get_node("Vacuum_Buff").free_buff()
		
		Funcs.regular_explosion(1.2, 1.2, global_position, Funcs.get_bullets_node(), 6, true)
		queue_free()

func get_vacuum_debuff(enemy : Enemy) -> Buff_Speed_Enemy:
	var vacuum_buff := Buff_Speed_Enemy.new()
	if enemy.is_in_group("Big_Enemies"):
		vacuum_buff.weight_to_modify = 1.5
	else: vacuum_buff.weight_to_modify = 2.5
	vacuum_buff.duration = 0
	vacuum_buff.name = "Vacuum_Buff"
	return vacuum_buff

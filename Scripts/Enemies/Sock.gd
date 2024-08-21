extends Enemy

@onready var sprite := get_node("AnimatedSprite2D")

var merger := false
var merged := false
var sock_to_merge : Node

var big_sock := preload("res://Scenes/Enemies/big_sock.tscn")

func _physics_process(_delta):
	if sock_to_merge != null:
		sprite.flip_h = global_position.x < sock_to_merge.global_position.x
		if global_position.distance_to(sock_to_merge.global_position) < 5:
			create_big_sock()
			Funcs.particles(Vector2(1.6,1.6), global_position, Color.ORANGE_RED)
			Funcs.sound_play_2d("res://Sounds/CheeseTransmutation.mp3", global_position, 6, 1.3)
			sock_to_merge.queue_free()
			queue_free()
	else:
		sprite.flip_h = global_position.x < player.global_position.x
	
	if velocity == Vector2.ZERO:
		sprite.stop()
	elif not sprite.is_playing():
		sprite.play()

func _on_die():
	Funcs.regular_explosion(0.6, 0.6, global_position, Funcs.get_bullets_node(), 2, true)

# Se reinicia la media en _exit_tree y no cuando se emite die ya que no siempre los enemigos emiten die al desaparecer
func _exit_tree():
	if sock_to_merge != null: # Esta media murio por lo que la media con la que se iba a fusionar debe reiniciar su estado de fusion
		sock_to_merge.merged = false
		sock_to_merge.moving = true

# Despues de unos segundos de aparecer, la media busca fusionarse con otra
func merge():
	# Si esta media esta siendo buscada por otra para fusionarse, o ya esta buscando una media para fusionarse, no hacer nada
	if merged or sock_to_merge != null: return
	
	var exceptions := [self] # Excepciones al escanear enemigos
	for i in 5:
		var enemy = Funcs.scan_for_enemy(100, sock_to_merge, self, exceptions) # Enviar como excepcion de escaneo a si mismo para que no intente fusionarse a si mismo
		if enemy == null: continue
		if enemy.is_in_group("Sock"):
			sock_to_merge = enemy
			break
		else: exceptions.append(enemy)
	if sock_to_merge == null: return # No se encontro ninguna media cercana, no hacer nada
	
	merger = true
	sock_to_merge.merged = true
	
	sock_to_merge.moving = false
	set_custom_target_position(sock_to_merge.global_position)
	# Si la media a fusionar ya no existe, reiniciar la posicion destino
	sock_to_merge.tree_exited.connect(_on_sock_to_merge_exited)
	update_merged_pos_timer.start()

func _on_sock_to_merge_exited():
	reset_custom_target_position(false)

@onready var update_merged_pos_timer := get_node("Update_Merged_Pos")
func set_merged_sock_pos() -> void:
	if sock_to_merge == null: return
	update_merged_pos_timer.start()
	set_custom_target_position(sock_to_merge.global_position)

func create_big_sock() -> void:
	var big_sock_instance : Enemy = big_sock.instantiate()
	
	Vars.main_scene.get_node("Enemies").add_child(big_sock_instance)
	big_sock_instance.global_position = global_position
	
	big_sock_instance.base_max_life = int((base_max_life + sock_to_merge.base_max_life) * 1.5)
	big_sock_instance.max_life = big_sock_instance.base_max_life
	big_sock_instance.life = big_sock_instance.base_max_life
	big_sock_instance.base_damage = int((base_damage + sock_to_merge.base_damage) * 1.2)
	big_sock_instance.damage = big_sock_instance.base_damage
	big_sock_instance.base_speed = int(max(base_speed, sock_to_merge.base_speed) * 0.8)
	big_sock_instance.speed = big_sock_instance.base_speed

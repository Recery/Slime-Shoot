extends Enemy

var can_attack := false

@onready var sprite := get_node("Sprite2D")
@onready var animation : AnimationPlayer = get_node("AnimationPlayer")
@onready var attack_cooldown := get_node("Attack_Cooldown")
@onready var spawn_pos := get_node("Spawn_Pos")
@onready var player_detecter : RayCast2D = get_node("Spawn_Pos/Player_Detecter")

func _physics_process(_delta):
	sprite.flip_h = global_position.x > player.global_position.x
	player_detecter.rotation = Funcs.get_angle(player.global_position, spawn_pos.global_position)
	player_detecter.rotation_degrees -= 90
	
	if global_position.distance_to(player.global_position) < 140:
		if can_attack:
			can_attack = false
			if Funcs.probability(70) and not player_detecter.get_collider() is TileMap:
				expansive_wave_attack()
			else:
				summon_stoddler()

var expansive_wave := preload("res://Scenes/Enemies/SandstoneGolem/expansive_wave.tscn")
func expansive_wave_attack():
	animation.current_animation = "crush"
	moving = false
	force_pathfinding_update()
	await animation.animation_finished
	
	var expansive_wave_instance = expansive_wave.instantiate()
	expansive_wave_instance.damage += base_damage - original_damage
	expansive_wave_instance.direction = (player.global_position - spawn_pos.global_position).normalized()
	
	if Funcs.add_to_bullets(expansive_wave_instance):
		expansive_wave_instance.global_position = spawn_pos.global_position
	else: expansive_wave_instance.queue_free()
	
	crush_anim()
	await get_tree().create_timer(1.6).timeout
	
	animation.current_animation = "walk"
	moving = true
	force_pathfinding_update()
	attack_cooldown.start()

var stoddler := preload("res://Scenes/Enemies/SandstoneGolem/stoddler.tscn")
func summon_stoddler():
	animation.current_animation = "crush"
	moving = false
	force_pathfinding_update()
	await animation.animation_finished
	
	var stoddler_instance : Enemy = stoddler.instantiate()
	stoddler_instance.base_damage += base_damage - original_damage
	stoddler_instance.base_speed += base_speed - original_speed
	stoddler_instance.base_max_life += base_max_life - original_max_life
	
	if Funcs.add_to_enemies(stoddler_instance):
		stoddler_instance.global_position = spawn_pos.global_position
	else: stoddler_instance.queue_free()
	
	crush_anim()
	await get_tree().create_timer(1.6).timeout
	
	animation.current_animation = "walk"
	moving = true
	force_pathfinding_update()
	attack_cooldown.start()

func crush_anim():
	Funcs.sound_play_2d("res://Sounds/Crush.mp3", 12, 0.9)
	for i in 9:
		var pos := Vector2(global_position.x + ((i-4)*5), global_position.y + 15)
		Funcs.particles(Vector2(2,2), pos, Color.WHITE_SMOKE)
	
	var original_pos : Vector2 = sprite.global_position
	for i in 10:
		var rand_extra_pos := Vector2(randi_range(-3, 3), randi_range(-3, 3))
		await get_tree().create_timer(0.05).timeout
		sprite.global_position = original_pos + rand_extra_pos
	sprite.global_position = original_pos

func _on_attack_cooldown_timeout():
	can_attack = true

func _on_die():
	Funcs.regular_explosion(2.5, 2.5, global_position, Funcs.get_bullets_node(), 8, true)

extends Summon_Minion

@onready var sprite := get_node("AnimatedSprite2D")

func _ready():
	can_shoot = false
	
	# Esperar 30 segundos para luego desaparecer el bot
	await get_tree().create_timer(30).timeout
	Funcs.particles(Vector2(1.5,1.5), global_position, Color.WHITE_SMOKE)
	queue_free()

func _physics_process(_delta) -> void:
	animation_management()
	idle_pos = player.global_position
	
	if targeted_enemy == null:
		idle_movement()
		# En este caso no hace falta hacer flip_h al sprite, siempre debe apuntar en la misma posición
	else:
		_move_to_enemy()


func animation_management() -> void:
	if velocity == Vector2.ZERO: sprite.animation = "idle"
	elif speed > 120: sprite.animation = "run"
	else: sprite.animation = "walk"

var move_to_enemy := true
func _move_to_enemy() -> void:
	speed = speed_weight * player.speed
	if global_position.distance_to(player.global_position) > 200:
		global_position = player.global_position 
		targeted_enemy = null
		return
	
	if global_position.distance_to(targeted_enemy.global_position) > 40: 
		move_to_enemy = true
	elif global_position.distance_to(targeted_enemy.global_position) < 20: 
		move_to_enemy = false
	
	if move_to_enemy:
		target_position = targeted_enemy.global_position
		move_to_pos(10)
	else:
		velocity = Vector2.ZERO
		if can_shoot: shoot()
	move_and_slide()

@onready var shoot_timer := get_node("Shoot_Cooldown")
var shot := preload("res://Scenes/Player/White_Slime/glacibot_shot.tscn")
func shoot() -> void:
	can_shoot = false
	shoot_timer.start()
	Funcs.sound_play_2d("res://Sounds/IceAttack.mp3", 8, 1.5)
	
	var shot_instance := shot.instantiate()
	if Funcs.add_to_bullets(shot_instance):
		shot_instance.global_position = global_position
		if targeted_enemy != null:
			shot_instance.direction = (targeted_enemy.global_position - global_position).normalized()
			shot_instance.rotation = Funcs.get_angle(targeted_enemy.global_position, global_position)
		else: shot_instance.queue_free()

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true

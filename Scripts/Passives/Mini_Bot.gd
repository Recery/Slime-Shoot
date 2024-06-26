extends Summon_Minion

var cannon

func _ready():
	can_shoot = true
	
	cannon = get_node("Cannon")

func _physics_process(_delta):
	set_cannon_offset()
	animation_management()
	
	if targeted_enemy == null: 
		idle_movement()
		flip_sprite_while_moving()
	else: 
		_move_to_enemy()
		flip_sprite_while_shooting()

var move_to_enemy = true
func _move_to_enemy():
	speed = speed_weight * player.speed
	if global_position.distance_to(player.global_position) > 200:
		global_position = player.global_position 
		targeted_enemy = null
		return
	
	if global_position.distance_to(targeted_enemy.global_position) > 50: 
		move_to_enemy = true
	elif global_position.distance_to(targeted_enemy.global_position) < 30: 
		move_to_enemy = false
	
	if move_to_enemy:
		target_position = targeted_enemy.global_position
		move_to_pos(15)
		flip_sprite_while_moving()
	else:
		velocity = Vector2.ZERO
		flip_sprite_while_shooting()
		if can_shoot: shoot()
	move_and_slide()

# Obtener todos estos nodos al instanciar al bot para evitar
# llamar a cada rato el metodo de get_node a cada rato
@onready var shoot_cooldown = get_node("Shoot_Cooldown")
@onready var laser_sound = get_node("Laser_Sound")
@onready var light = get_node("Light")
@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("Sprite2D")
var shot = preload("res://Scenes/Passives/mini_bot_shot.tscn")

func shoot():
	animation.current_animation = "shoot"
	
	var shot_instance = shot.instantiate()
	var direction = (targeted_enemy.global_position - cannon.global_position).normalized()
	shot_instance.direction = direction
	shot_instance.rotation = Funcs.get_angle(targeted_enemy.global_position, cannon.global_position)
	if not Funcs.add_to_bullets(shot_instance): return
	shot_instance.global_position = cannon.global_position
	can_shoot = false
	shoot_cooldown.start()
	laser_sound.play()
	light.show()

func animation_management():
	if animation.current_animation != "shoot":
		if velocity == Vector2.ZERO: animation.current_animation = "idle"
		elif speed < 120: animation.current_animation = "walk"
		else: animation.current_animation = "run"

func flip_sprite_while_moving():
	sprite.flip_h = velocity.x > 0

func flip_sprite_while_shooting():
	if targeted_enemy == null: return
	sprite.flip_h = not targeted_enemy.global_position < global_position

func set_cannon_offset():
	if sprite.flip_h:
		cannon.position.x = 4
		light.position.x = 3.5
	else:
		cannon.position.x = -4
		light.position.x = -3.5

func _on_shoot_cooldown_timeout():
	can_shoot = true
	shoot_cooldown.stop()

func _on_animation_player_animation_finished(anim_name):
	if anim_name != "shoot": return
	animation.current_animation = "idle"
	light.hide()

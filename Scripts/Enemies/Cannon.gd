extends Enemy

var can_shoot : bool
var cannon_cannon : Node

@onready var shoot_cooldown := get_node("Shoot_Cooldown")

func _ready():
	can_shoot = false
	cannon_cannon = get_node("Cannon_Cannon")
	shoot_cooldown.start()

func _physics_process(_delta) -> void:
	graphics()
	if global_position.distance_to(player.global_position) > 110 or not raycast_collider_is_player(): 
		moving = true
	else:
		moving = false
		if not is_in_group("Full_Freezed"): shoot()

var cannonball := preload("res://Scenes/Enemies/cannonball.tscn")
@onready var shoot_des = get_node("Cannon_Cannon/Shoot_Des")
@onready var shoot_pos = get_node("Cannon_Cannon/Shoot_Pos")
@onready var shoot_sound = get_node("Shoot_Sound")
@onready var fire = get_node("Cannon_Cannon/Fire")
@onready var fire_animation = get_node("Cannon_Cannon/Fire_animation")
func shoot() -> void:
	if not can_shoot: return
	
	var cannonball_instance = cannonball.instantiate()
	if not Funcs.add_to_bullets(cannonball_instance): return
	
	cannonball_instance.damage = damage - 3
	cannonball_instance.direction = (shoot_des.global_position - shoot_pos.global_position).normalized()
	cannonball_instance.global_position = shoot_pos.global_position
	cannonball_instance.rotation = cannon_cannon.rotation
	can_shoot = false
	shoot_sound.play()
	fire.show()
	fire_animation.current_animation = "fire"
	shoot_cooldown.start()

func _on_fire_animation_animation_finished(_anim_name):
	fire.hide()

func _on_shoot_cooldown_timeout():
	can_shoot = true

func raycast_collider_is_player():
	var raycast = get_node("Shoot_Dir")
	raycast.global_position = get_node("Cannon_Cannon/Shoot_Pos").global_position
	raycast.rotation = Funcs.get_angle(player.global_position, get_node("Cannon_Cannon/Shoot_Pos").global_position)
	if raycast.is_colliding():
		if is_instance_valid(raycast.get_collider(0)):
			if raycast.get_collider(0) == player:
				return true
	
	return false

func _on_die():
	Funcs.regular_explosion(1.9, 1.9, global_position, Vars.main_scene, 15, true)
	queue_free()

func graphics():
	var angle = atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x)
	if not is_in_group("Full_Freezed"):
		cannon_cannon.rotation = lerp_angle(cannon_cannon.rotation, angle, 0.015)
	
	var cannon_deg_mod = fmod(cannon_cannon.rotation_degrees, 360)
	if cannon_deg_mod < 0: cannon_deg_mod += 360
	if (cannon_deg_mod <= 60 || cannon_deg_mod >= 300):
		hide_v_wheels()
		get_node("Wheel1_h").position = Vector2(5.25, 1.75)
		get_node("Wheel2_h").position = Vector2(-1.75, 4.75)
		if velocity != Vector2.ZERO:
			get_node("Wheel2_h").rotation_degrees += 1.25 + (speed * 0.025)
			get_node("Wheel1_h").rotation_degrees += 1.25 + (speed * 0.025)
		cannon_cannon.frame = 0
		cannon_cannon.position.x = 2.25
		get_node("Cannon_Center").frame = 0
		
	elif (cannon_deg_mod > 60 && cannon_deg_mod <= 120):
		hide_h_wheels()
		cannon_cannon.rotation_degrees -= 0.1
		cannon_cannon.frame = 1
		get_node("Cannon_Center").frame = 0
		if velocity != Vector2.ZERO: get_node("AnimationVWheels").current_animation = "wheel_move"
		else: get_node("AnimationVWheels").current_animation = "stop"
		cannon_cannon.position.x = 1.25
	elif (cannon_deg_mod > 120 && cannon_deg_mod <= 240):
		hide_v_wheels()
		if velocity != Vector2.ZERO:
			get_node("Wheel2_h").rotation_degrees -= 1.25 + (speed * 0.025)
			get_node("Wheel1_h").rotation_degrees -= 1.25 + (speed * 0.025)
		get_node("Wheel1_h").position = Vector2(-4.75, 1.75)
		get_node("Wheel2_h").position = Vector2(2, 4.75)
		cannon_cannon.frame = 0
		get_node("Cannon_Center").frame = 0
		cannon_cannon.position.x = 2.25
	elif (cannon_deg_mod > 240):
		hide_h_wheels()
		cannon_cannon.rotation_degrees += 0.1
		cannon_cannon.frame = 1
		get_node("Cannon_Center").frame = 1
		if velocity != Vector2.ZERO: get_node("AnimationVWheels").current_animation = "wheel_move"
		else: get_node("AnimationVWheels").current_animation = "stop"
		cannon_cannon.position.x = 1.25

func hide_h_wheels():
	get_node("Wheel2_h").hide()
	get_node("Wheel1_h").hide()
	get_node("Wheel1_v").show()
	get_node("Wheel2_v").show()

func hide_v_wheels():
	get_node("Wheel2_h").show()
	get_node("Wheel1_h").show()
	get_node("Wheel2_v").hide()
	get_node("Wheel1_v").hide()

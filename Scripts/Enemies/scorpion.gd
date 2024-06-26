extends Enemy

var can_shoot := false

@onready var sprite = get_node("Scorpion")
@onready var shoot_pos = get_node("Shoot_Pos")
@onready var shoot_raycast = get_node("Shoot_Pos/Shoot_Raycast")

func _physics_process(_delta):
	if player.global_position.x < global_position.x:
		sprite.flip_h = false
		shoot_pos.position.x = 5
	else:
		sprite.flip_h = true
		shoot_pos.position.x = -5
	
	if is_in_group("Full_Freezed"): return
	
	if global_position.distance_to(player.global_position) > 125:
		moving = true
	elif global_position.distance_to(player.global_position) < 100:
		moving = false
	
	shoot_raycast.rotation = Funcs.get_angle(shoot_pos.global_position, player.global_position)
	
	if shoot_raycast.get_collider() == Vars.player:
		if not moving and can_shoot: shoot()
	else: moving = true
	if velocity != Vector2.ZERO: sprite.play("walk")

@onready var stinger := preload("res://Scenes/Enemies/scorpion_stinger.tscn")
@onready var timer := get_node("Shoot_Cooldown")
@onready var bullets_node : Node = Funcs.get_bullets_node()
func shoot():
	if waiting_player: return
	
	timer.start()
	can_shoot = false
	
	sprite.play("shoot")
	
	var stinger_instance = stinger.instantiate()
	stinger_instance.direction = (player.global_position - shoot_pos.global_position).normalized()
	stinger_instance.rotation = Funcs.get_angle(player.global_position, shoot_pos.global_position)
	bullets_node.add_child(stinger_instance)
	stinger_instance.global_position = shoot_pos.global_position

func _on_shoot_cooldown_timeout():
	can_shoot = true
	if velocity != Vector2.ZERO:
		sprite.play("walk")

func _on_scorpion_animation_looped():
	if velocity == Vector2.ZERO:
		sprite.stop()

func _on_die():
		Funcs.color_explosion(1,1,global_position, bullets_node, 5, true, Color.html("#4e495f"))

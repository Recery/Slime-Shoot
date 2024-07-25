extends Enemy

@onready var cannon := get_node("Center/Pivot/Cannon")
@onready var shoot_pos := get_node("Center/Pivot/Shoot_Pos")
@onready var pivot := get_node("Center/Pivot")
@onready var wheel_1 := get_node("Wheel_1")
@onready var wheel_2 := get_node("Wheel_2")
@onready var shoot_ray := get_node("Center/Pivot/Shoot_Ray")
@onready var shoot_timer := get_node("Shoot_Timer")
@onready var shoot_sound := get_node("Shoot_Sound")

func _physics_process(_delta):
	graphics()
	
	if can_shoot and not moving: shoot()
	
	if global_position.distance_to(player.global_position) > 110:
		moving = true
		# No avanzar inmediatamente ya que quedo con la posicion anterior y hace unos pocos pasos para esa direccion
	elif global_position.distance_to(player.global_position) < 80:
		if shoot_ray.get_collider() == Vars.player:
			moving = false
			apply_new_speed() # Parar inmediatamente
		else: moving = true

func graphics() -> void:
	var angle = Funcs.get_angle(player.global_position, global_position)
	pivot.rotation = angle
	
	if player.global_position.x > global_position.x:
		cannon.flip_v = false
		if velocity != Vector2.ZERO:
			wheel_1.rotation_degrees += speed * 0.08
			wheel_2.rotation_degrees += speed * 0.08
		wheel_1.position.x = 2
		wheel_2.position.x = -3
	else:
		cannon.flip_v = true
		if velocity != Vector2.ZERO:
			wheel_1.rotation_degrees -= speed * 0.08
			wheel_2.rotation_degrees -= speed * 0.08
		wheel_1.position.x = -2
		wheel_2.position.x = 3

@onready var fire := get_node("Center/Pivot/Fire")
@onready var animation := get_node("Center/Pivot/Animation_Fire")

var snowball := preload("res://Scenes/Enemies/cannon_snowball.tscn")
func shoot():
	fire.visible = true
	animation.current_animation = "fire"
	var animation_ended := func(_anim_name):
		fire.visible = false
	animation.animation_finished.connect(animation_ended)
	
	var snowball_instance := snowball.instantiate()
	if Funcs.add_to_bullets(snowball_instance):
		snowball_instance.damage = max(damage - 1, 1)
		snowball_instance.global_position = shoot_pos.global_position
		snowball_instance.direction = (player.global_position - shoot_pos.global_position).normalized()
		snowball_instance.rotation = pivot.rotation
	else: snowball_instance.queue_free()
	
	shoot_sound.play()
	shoot_timer.start()
	can_shoot = false

var can_shoot := false
func _on_shoot_timer_timeout():
	can_shoot = true


func _on_die():
	Funcs.color_explosion(0.8, 0.8, global_position, Funcs.get_bullets_node(), 5, true, Color.SKY_BLUE)

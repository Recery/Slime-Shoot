extends Sprite2D

@onready var head := get_node("Head")
@onready var cannon := get_node("Head/Cannon")
@onready var shoot_cooldown := get_node("Shoot_Cooldown")
@onready var shoot_sound := get_node("Shoot_Sound")
@onready var player := Vars.player

var can_shoot := false

func _physics_process(_delta):
	var angle = Funcs.get_angle(player.global_position, global_position)
	head.rotation = lerp_angle(head.rotation, angle, 0.04)
	
	if can_shoot: shoot()

var shot = preload("res://Scenes/Enemies/MummifiedSlime/enemy_laser_turret_shot.tscn")
func shoot():
	can_shoot = false
	shoot_cooldown.start()
	shoot_sound.play()
	
	var shot_instance := shot.instantiate()
	shot_instance.pos_control = cannon
	shot_instance.rotation_control = head
	if not Funcs.add_to_bullets(shot_instance): return
	
	head.frame = 1
	if shot_instance != null:
		await shot_instance.tree_exited
	head.frame = 0

func _on_shoot_cooldown_timeout():
	can_shoot = true

func _on_despawn_timer_timeout():
	Funcs.regular_explosion(1.2, 1.2, global_position, Funcs.get_bullets_node(), 6, true)
	queue_free()

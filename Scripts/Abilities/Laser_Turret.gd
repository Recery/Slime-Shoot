extends Sprite2D

@onready var wall_detecter := get_node("Head/Walls_Detecter")
@onready var shoot_cooldown := get_node("Shoot_Cooldown")

var head
var cannon
var scan_range := 110

var can_shoot := true
var targeted_enemy : Node

func _ready():
	head = get_node("Head")
	cannon = get_node("Head/Cannon")

func _physics_process(_delta):
	if targeted_enemy != null: 
		if targeted_enemy.global_position.distance_to(global_position) > scan_range:
			targeted_enemy = null
			return
		
		var angle = Funcs.get_angle(targeted_enemy.global_position, global_position)
		head.rotation = lerp_angle(head.rotation, angle, 0.04)
		
		if can_shoot:
			if is_instance_valid(wall_detecter.get_collider()):
				if not wall_detecter.get_collider() is TileMap: shoot()

var shot = preload("res://Scenes/Abilities/laser_turret_shot.tscn")
@onready var shoot_sound = get_node("Shoot_Sound")
func shoot():
	can_shoot = false
	shoot_cooldown.start()
	shoot_sound.play()
	
	var shot_instance := shot.instantiate()
	shot_instance.pos_control = cannon
	shot_instance.rotation_control = head
	if not Funcs.add_to_bullets(shot_instance): return
	
	head.frame = 1
	await get_tree().create_timer(0.9, false).timeout
	head.frame = 0

func _on_scan_timer_timeout():
	targeted_enemy = Funcs.scan_for_enemy(scan_range, targeted_enemy, self)

func _on_shoot_cooldown_timeout():
	can_shoot = true

func _on_despawn_timer_timeout():
	Funcs.regular_explosion(1.2, 1.2, global_position, Funcs.get_bullets_node(), 6, true)
	queue_free()

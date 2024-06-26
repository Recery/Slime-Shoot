extends Sprite2D

@onready var wall_detecter := get_node("Head/Walls_Detecter")
@onready var head := get_node("Head")
@onready var cannon := get_node("Head/Cannon")

var scan_range := 125

var can_shoot := true
var targeted_enemy

func _physics_process(_delta):
	if targeted_enemy != null: 
		if targeted_enemy.global_position.distance_to(global_position) > scan_range:
			targeted_enemy = null
			return
		head.rotation = Funcs.get_angle(targeted_enemy.global_position, global_position)
		if can_shoot:
			if is_instance_valid(wall_detecter.get_collider()):
				if not wall_detecter.get_collider() is TileMap: shoot()
#				else: targeted_enemy = Funcs.scan_for_enemy(scan_range, null, self, [targeted_enemy])

@onready var shoot_cooldown = get_node("Shoot_Cooldown")
@onready var shoot_sound = get_node("Shoot_Sound")
@onready var shoot_anim = get_node("Shoot_Anim")
@onready var despawn_timer = get_node("Despawn_Timer")
var bullet = preload("res://Scenes/Weapons/weedtite_bullet.tscn")
func shoot() -> void:
	# Añade 0.28 segundos de vida cada vez que dispara
	if despawn_timer.time_left + 0.28 < despawn_timer.wait_time:
		despawn_timer.start(despawn_timer.time_left + 0.28)
	else: despawn_timer.start()
	
	can_shoot = false
	shoot_cooldown.start()
	shoot_sound.play()
	shoot_anim.current_animation = "shoot"
	var bullet_instance = bullet.instantiate()
	var direction = (targeted_enemy.global_position - cannon.global_position).normalized()
	var angle = Funcs.get_angle(targeted_enemy.global_position, cannon.global_position)
	bullet_instance.rotation = angle
	bullet_instance.direction = direction
	bullet_instance.generated_by = 1
	
	if not Funcs.add_to_bullets(bullet_instance): return
	bullet_instance.global_position = cannon.global_position

func _on_scan_timer_timeout():
	targeted_enemy = Funcs.scan_for_enemy(scan_range, targeted_enemy, self)

func _on_shoot_cooldown_timeout():
	can_shoot = true

func _on_despawn_timer_timeout():
	Funcs.regular_explosion(1.2, 1.2, global_position, Funcs.get_bullets_node(), 5, true)
	queue_free()

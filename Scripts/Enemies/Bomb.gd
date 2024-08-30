extends Enemy

var explode_detecter : Node
@onready var sprite := get_node("Sprite2D")

func _ready():
	explode_detecter = get_node("Explode_Detecter")
	disconnect("die", _when_die)

func _physics_process(_delta) -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	var raycast_angle = Funcs.get_angle(explode_detecter.global_position, player.global_position) + 1.5708
	explode_detecter.rotation = raycast_angle
	
	if velocity == Vector2.ZERO and not already_emitted: anim_player.stop()
	elif not anim_player.is_playing(): anim_player.play()
	
	if is_instance_valid(explode_detecter.get_collider()):
		if explode_detecter.get_collider().is_in_group("Player_Slime"):
			die.emit()

@onready var anim_player = get_node("AnimationPlayer")
func explode():
	moving = false
	force_pathfinding_update()
	anim_player.current_animation = "explode_1"
	await get_tree().create_timer(1).timeout
	anim_player.current_animation = "explode_2"
	await get_tree().create_timer(1).timeout
	anim_player.current_animation = "explode_3"
	await get_tree().create_timer(1).timeout
	anim_player.current_animation = "explode_4"
	await get_tree().create_timer(0.1).timeout

func _on_die():
	# Arreglar explosión para colisión
	if already_emitted: return
	already_emitted = true
	await explode()
	
	set_collision_mask_value(5, false)
	Funcs.regular_explosion(3.2, 3.2, global_position, Funcs.get_bullets_node(), 15, true)
	damage *= 2
	get_node("CollisionShape2D").scale = Vector2(3.75, 3.75)
	player.add_score.emit(int((max_life - life)*0.2), self)
	
	if not Vars.almanac_unlocked.has(scene_file_path) and scene_file_path != "":
		Vars.almanac_unlocked.append(scene_file_path)
		Save_System.save_almanac()
	
	await get_tree().create_timer(0.1).timeout
	
	queue_free()

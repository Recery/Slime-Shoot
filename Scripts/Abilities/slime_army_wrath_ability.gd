extends Ability

func _ready(): set_physics_process(false)

@onready var ray_sound := get_node("Ray_Sound")
func _on_activate():
	player.add_child(get_damage_buff())
	
	for minion in player.summons_module.minions:
		if minion == null: continue
		minion.add_child(Timered_Particles.new(8, 0.25, Color.ORANGE))
	
	set_physics_process(true)

func get_damage_buff() -> Buff_Damage_Player:
	var buff := Buff_Damage_Player.new() 
	buff.weight_to_add = 3
	buff.duration = 9
	buff.affected_damage_type = buff.damage_types.SUMMON
	buff.tree_exited.connect(reset_effects)
	return buff

var ray_texture := preload("res://Sprites/Abilities/PowerUpRay.png")
var rays : Array[Sprite2D]
func get_power_up_ray(assigned_minion : Node2D) -> Sprite2D:
	var ray := Sprite2D.new()
	Funcs.add_to_bullets(ray)
	ray.texture = ray_texture
	ray.hframes = 2
	
	ray.set_meta("assigned_minion", assigned_minion)
	
	var anim_tween := get_tree().create_tween().set_loops()
	anim_tween.tween_property(ray, "frame", 1, 0.1)
	anim_tween.tween_property(ray, "frame", 0, 0.1)
	anim_tween.bind_node(ray)
	
	return ray

func setup_minion_with_ray(minion : Node2D) -> void:
	if not minion.is_in_group("slime_army_wrath_ray"):
		minion.add_to_group("slime_army_wrath_ray")
		rays.append(get_power_up_ray(minion))

func _physics_process(_delta):
	Funcs.remove_array_elements(rays, null)
	
	for minion in player.summons_module.minions:
		if minion != null: setup_minion_with_ray(minion)
	for turret in player.summons_module.turrets: 
		if turret != null: setup_minion_with_ray(turret)
	
	for ray in rays:
		if ray == null: continue
		if ray.has_meta("assigned_minion"):
			var minion = ray.get_meta("assigned_minion")
			if minion == null:
				ray.queue_free()
				continue
			ray.scale.y = player.global_position.distance_to(minion.global_position) / ray.texture.get_height()
			ray.rotation = Funcs.get_angle(player.global_position, minion.global_position) - deg_to_rad(90)
			ray.global_position = (player.global_position + minion.global_position) / 2
			if not ray_sound.is_playing(): ray_sound.play()

# Cuando termina el buff, reinicia todos los efectos visuales
func reset_effects() -> void:
	set_physics_process(false)
	
	for minion in player.summons_module.minions: 
		if minion != null: destructor_ray_with_minion(minion)
	for turret in player.summons_module.turrets:
		if turret != null: destructor_ray_with_minion(turret)
	
	for ray in rays:
		if ray != null: ray.queue_free()
	
	Funcs.remove_array_elements(rays, null)

func destructor_ray_with_minion(minion : Node2D) -> void:
	if minion.is_in_group("slime_army_wrath_ray"):
		minion.remove_from_group("slime_army_wrath_ray")

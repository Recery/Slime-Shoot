extends Enemy

@onready var sprite := get_node("Ball")
@onready var shading := get_node("Shading")

func _ready():
	sprite.frame = randi_range(0,5)
	shading.frame = sprite.frame + 6

func _physics_process(_delta) -> void:
	if velocity != Vector2.ZERO:
		if velocity.x < 0:
			sprite.rotation -= float("0.0" + str(speed))
		else:
			sprite.rotation += float("0.0" + str(speed))

func _on_die():
	Funcs.regular_explosion(0.8, 0.8, global_position, Vars.main_scene, 2, true)

var illusion := preload("res://Scenes/Enemies/false_evil_ball.tscn")
func summon_illusion() -> void:
	if waiting_player or Funcs.probability(15) or is_in_group("Full_Freezed"): return
	# Esperar un poco e inmovilizar para dar un
	# efecto de que está invocando la ilusión
	moving = false
	await get_tree().create_timer(0.9).timeout
	
	var illusion_instance : Enemy = illusion.instantiate()
	get_parent().add_child(illusion_instance)
	illusion_instance.global_position = global_position
	Funcs.particles(Vector2(2.5,2.5), global_position, Color.MEDIUM_PURPLE)
	
	if not illusion_instance.is_node_ready(): await illusion_instance.ready
	illusion_instance.base_speed = base_speed + 8
	illusion_instance.speed = base_speed + 8
	illusion_instance.force_pathfinding_update()
	
	moving = true

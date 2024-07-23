extends Ability

func _ready():
	set_physics_process(false)

func _physics_process(_delta) -> void:
	Funcs.particles(Vector2(1.2,1.2), player.global_position, Color(0.365, 1, 0.337), Vars.main_scene)

@onready var use_sound := get_node("Use_Sound")
func _on_activate() -> void:
	use_sound.play()
	player.add_child(get_speed_buff())
	set_physics_process(true) # Al activar physics_process se van generando particulas

func disable_particles() -> void:
	if is_physics_processing():
		set_physics_process(false) # Desactivar physics_process para dejar de generar particulas

func get_speed_buff() -> Buff_Player:
	var buff := Buff_Player.new()
	buff.speed_weight_to_modify = 1.35
	buff.duration = 8
	buff.buff_removed.connect(disable_particles)
	return buff

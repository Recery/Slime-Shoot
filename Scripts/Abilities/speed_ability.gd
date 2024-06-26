extends Ability

func _ready():
	set_physics_process(false)

func _physics_process(_delta):
	Funcs.particles(Vector2(1.2,1.2), player.global_position, Color(0.365, 1, 0.337), Vars.main_scene)

func _on_activate():
	get_node("Duration_Timer").start()
	get_node("Use_Sound").play()
	player.modify_speed.emit(player.speed * 1.35)
	set_physics_process(true)

func _on_duration_timer_timeout():
	get_node("Duration_Timer").stop()
	player.modify_speed.emit(player.speed / 1.35)
	set_physics_process(false)

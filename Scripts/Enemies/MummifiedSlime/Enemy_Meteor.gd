extends Enemy_Projectile

var shoot_pos : Vector2 # El enemigo que invoca el meteorito debe asignar esta variable

func _physics_process(delta:float) -> void:
	if not stop_working:
		global_position += direction * speed * delta
	
	if global_position.y > shoot_pos.y and not stop_working:
		explode()

func _on_particles_timer_timeout() -> void:
	Funcs.particles(Vector2(1.5,1.5), global_position, Color.html("#ffa15f"))

func explode() -> void:
	get_node("CollisionShape2D").disabled = false
	Funcs.regular_explosion(3,3, global_position, Funcs.get_bullets_node(), 6, true)
	die.emit()

extends Friendly_Projectile

var mouse_pos : Vector2

func _ready() -> void:
	mouse_pos = get_global_mouse_position()

func _physics_process(delta:float) -> void:
	if not stop_working:
		global_position += direction * speed * delta
	
	if global_position.y > mouse_pos.y && not stop_working:
		explode()

func _on_particles_timer_timeout() -> void:
	Funcs.particles(Vector2(1.5,1.5), global_position, Color.html("#ffa15f"))

func explode() -> void:
	stop_working = true
	monitoring = true
	Funcs.regular_explosion(3,3, global_position, Funcs.get_bullets_node(), 6, true)
	die.emit()

func _on_body_entered(body) -> void:
	if body.is_in_group("Enemies"):
		Funcs.deal_damage(body, damage)

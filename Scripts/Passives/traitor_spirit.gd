extends Friendly_Projectile

func _ready():
	add_child(Timered_Particles.new(0, 0.1, Color.STEEL_BLUE, Vector2.ONE))
	await get_tree().create_timer(1).timeout
	monitoring = true

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or stop_working: return
	
	Funcs.deal_damage(body, damage)
	die.emit()

func _on_die():
	Funcs.color_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 0, false, Color.STEEL_BLUE)

var current_point := randi_range(0, total_points)
const total_points := 15
const radius := 30

func _extra_physics_process():
	var target_position := get_circle()
	direction = (target_position - global_position).normalized()
	
	rotation = direction.angle()
	
	if global_position.distance_to(target_position) < 10:
		current_point = (current_point + 1) % total_points

func get_circle() -> Vector2:
	var angle := current_point * (2 * PI / total_points)
	var x := Vars.player.global_position.x + radius * cos(angle)
	var y := Vars.player.global_position.y + radius * sin(angle)
	return Vector2(x, y)

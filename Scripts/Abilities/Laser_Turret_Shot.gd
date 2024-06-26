extends Friendly_Projectile

var enemies_in_area : Array[Node]

var pos_control : Node
var rotation_control : Node

func _physics_process(_delta):
	if pos_control == null or rotation_control == null: 
		visible = false
		return
	
	rotation = rotation_control.rotation
	global_position = pos_control.global_position
	visible = true

func _on_body_entered(body):
	if not body.is_in_group("Player_Slime"):
		if body.is_in_group("Enemies") && not stop_working:
			enemies_in_area.append(body)

func _on_body_exited(body):
	if not body.is_in_group("Player_Slime"):
		if body.is_in_group("Enemies") && not stop_working:
			enemies_in_area.erase(body)

@onready var collision_shape = get_node("CollisionShape2D").shape
func _on_damage_timer_timeout():
	for enemy in enemies_in_area:
		Funcs.deal_damage(enemy, damage)
	
	var segment_size : int = collision_shape.size.x / 10
	for i in range(10):
		var pos = to_global(Vector2(segment_size*i, 2))
		Funcs.particles(Vector2(1,1), pos, Color.RED)

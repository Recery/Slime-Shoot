extends Area2D

var enemies_affected := []
var player

func _ready():
	player = Vars.player
	Funcs.color_explosion(4, 4, global_position, Vars.main_scene.get_node("Summons"), 0, false, Color(0.882, 0.922, 1))

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		enemies_affected.append(body)

func _on_body_exited(body):
	for enemy in enemies_affected:
		if body == enemy:
			enemies_affected.erase(body)
			break

func _on_despawn_timer_timeout():
	for enemy in enemies_affected:
		enemy.add_child(get_freeze_debuff())
	create_particles()
	queue_free()

func get_freeze_debuff():
	var debuff := Buff_Speed_Enemy.new()
	debuff.weight_to_modify = 0
	debuff.duration = 4
	debuff.color = Color(0.639, 0.757, 1)
	return debuff

func create_particles():
	for i in range(9):
		var angle = i * (2 * PI / 9)
		var x = global_position.x + 21 * cos(angle)
		var y = global_position.y + 21 * sin(angle)
		Funcs.particles(Vector2(0.8,0.8), Vector2(x,y), Color(0.882, 0.922, 1))
	
	for i in range(18):
		var angle = i * (2 * PI / 18)
		# 42.44 es el radio del circulo de la colision
		var x = global_position.x + 42.44 * cos(angle)
		var y = global_position.y + 42.44 * sin(angle)
		Funcs.particles(Vector2(1.2,1.2), Vector2(x,y), Color(0.882, 0.922, 1))

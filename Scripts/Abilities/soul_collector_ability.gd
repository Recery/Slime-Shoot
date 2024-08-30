extends Ability
# 30 starter
@onready var use_sound := get_node("Use_Sound")
@onready var particles_timer := get_node("Particles_Timer")
func _on_activate() -> void:
	use_sound.play()
	particles_timer.start()
	Funcs.color_explosion(1, 1, player.global_position, player, 0, false, Color.WHITE_SMOKE)
	
	player.add_score.connect(enemy_killed)
	await get_tree().create_timer(3).timeout
	player.add_score.disconnect(enemy_killed)
	
	particles_timer.stop()

func enemy_killed(points, enemy) -> void:
	if points <= 0 or enemy.is_in_group("Dungeon_Enemy"): return
	create_soul_orb(enemy.global_position)

func create_particles() -> void:
	Funcs.particles(Vector2(2.2,1.8), player.global_position, Color.WHITE_SMOKE, player)

@onready var collect_soul_sound = get_node("Collect_Soul_Sound")
var soul_orbs : Array[Sprite2D]
func create_soul_orb(pos : Vector2) -> void:
	var soul_orb := Sprite2D.new()
	if Funcs.add_to_bullets(soul_orb):
		soul_orb.texture = load("res://Sprites/Abilities/Soul.png")
		soul_orb.modulate.a = 0.5
		soul_orb.global_position = pos
		soul_orb.add_child(Timered_Smoke.new(0, 0.05, Vector2(0.5,0.5)))
		soul_orbs.append(soul_orb)
	else: soul_orb.queue_free()

func _physics_process(delta) -> void:
	if soul_orbs.size() < 1: return
	
	for orb in soul_orbs:
		if orb == null: continue
		var dir := (player.global_position - orb.global_position).normalized()
		orb.global_position += dir * (abs(player.speed) * 1.2) * delta
		orb.rotation = dir.angle()
		if orb.global_position.distance_to(player.global_position) < 5:
			player.max_life += 1
			Funcs.color_explosion(0.75, 0.75, player.global_position, player, 0, false, Color.WHITE_SMOKE)
			collect_soul_sound.play()
			orb.queue_free()
	
	Funcs.remove_array_elements(soul_orbs, null)

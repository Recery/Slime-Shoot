extends Player

@onready var mark_cooldown := get_node("Mark_Cooldown")
var marked_enemies : Array[Node]
var create_particles := true

func _input(event):
	if event.is_action_pressed("perk"):
		perk_activated = true
	elif event.is_action_released("perk"):
		perk_activated = false

func _on_extra_physics_process():
	if perk_activated:
		if reduce_energy(1.3, 0.5):
			if mark_cooldown.is_stopped():
				mark_cooldown.start()
			if create_particles:
				var particle_size = Vector2(2.2-mark_cooldown.time_left, 2.2-mark_cooldown.time_left)
				Funcs.particles(particle_size, global_position, Color.html("#fffab2"))
				create_particles = false
		else:
			perk_activated = false
	else:
		if not mark_cooldown.is_stopped():
			mark_cooldown.stop()

var mark = preload("res://Scenes/Player/Cosmic_Slime/stellar_marked.tscn")
@onready var animation := get_node("Animation_Player_Slime")
func _on_mark_cooldown_timeout():
	Funcs.sound_play("res://Sounds/Stellar_Mark.mp3",-5,0)
	animation.current_animation = "bounce_bright"
	
	var exceptions := marked_enemies
	for i in range(10):
		var marked_enemy = Funcs.scan_for_enemy(150, null, self, exceptions)
		if marked_enemy != null and not marked_enemy.is_in_group("Boss"):
			marked_enemy.add_child(mark.instantiate())
			Funcs.deal_damage(marked_enemy, marked_enemy.life / 2)
			marked_enemy.damage /= 2
			marked_enemies.append(marked_enemy)
			break
		elif marked_enemy != null:
			if marked_enemy.is_in_group("Boss"):
				exceptions.append(marked_enemy)
	
	var i := 0
	while i < marked_enemies.size():
		if marked_enemies[i] == null:
			marked_enemies.remove_at(i)
		else: i += 1

func _on_animation_player_slime_animation_finished(_anim_name):
	animation.current_animation = "bounce_shadow"

func _on_particle_timer_timeout():
	create_particles = true

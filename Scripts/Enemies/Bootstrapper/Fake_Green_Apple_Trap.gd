extends Enemy_Projectile

var green_apple := preload("res://Scenes/Abilities/green_apple.tscn")
func _on_area_entered(area):
	if not area.is_in_group("Player_Slime") or stop_working: return
	if Vars.player == null: return
	
	var green_apple_instance := green_apple.instantiate()
	green_apple_instance.name = "Fake_Green_Apple"
	Vars.player.add_child(green_apple_instance)
	green_apple_instance.frame_changed.connect(_on_apple_frame_changed)
	green_apple_instance.play("fake")
	
	set_deferred("monitoring", false)
	visible = false

var frame_count := 0
func _on_apple_frame_changed():
	Funcs.sound_play("res://Sounds/Crunch.mp3", 20, 1.25)
	Funcs.particles(Vector2(1.5,1.5), Vars.player.global_position, Color.GREEN)
	if frame_count < 1:
		frame_count += 1
	elif Vars.player.has_node("Fake_Green_Apple"):
		Vars.player.get_node("Fake_Green_Apple").queue_free()
		Vars.player.add_child(get_damage_debuff())
		Vars.player.deal_damage_special(damage)
		die.emit()

func get_damage_debuff() -> Buff_Damage_Player:
	var debuff := Buff_Damage_Player.new()
	debuff.duration = 4
	debuff.weight_to_add = 0.75
	debuff.color = Color.YELLOW_GREEN
	return debuff

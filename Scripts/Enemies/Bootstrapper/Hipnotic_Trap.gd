extends Enemy_Projectile

func get_speed_debuff() -> Buff_Speed_Player:
	var debuff := Buff_Speed_Player.new()
	debuff.duration = 5
	debuff.color = Color.MEDIUM_PURPLE
	debuff.weight_to_modify = -1
	debuff.tree_exiting.connect(func(): die.emit())
	return debuff

func _on_area_entered(area):
	if not area.is_in_group("Player_Slime") or stop_working: return
	if Vars.player == null: return
	
	Vars.player.add_child(get_speed_debuff())
	Vars.player.deal_damage_special(0) # Solo se llama ese metodo para emitir el sonido de daño
	
	get_node("Base").frame = 1
	spiral_sprite.frame = 3
	
	set_deferred("monitoring", false)

@onready var spiral_sprite := get_node("Spiral")
# Este proyectil no se mueve, no importa sobreescribir physics_process
func _physics_process(_delta):
	spiral_sprite.rotation_degrees += 1

func _on_die():
	Funcs.color_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 2, true, Color.VIOLET)

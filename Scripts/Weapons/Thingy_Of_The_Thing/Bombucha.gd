extends Friendly_Projectile

func _ready() -> void:
	get_node("Sprite2D").flip_v = direction.x < 0

func set_frame(frame:int):
	get_node("Sprite2D").frame = frame

var enemy_damaged := false
func _on_body_entered(body) -> void:
	if not body.is_in_group("Enemies") or body == null or enemy_damaged: return
	# En este punto, el body si o si es un enemigo
	
	enemy_damaged = true
	Funcs.deal_damage(body, 2)
	if not body.is_in_group("Big_Enemies") and not body.is_in_group("Boss"):
		body.add_child(Knockback.new(700))
	die.emit()

func _on_die():
	Funcs.sound_play_2d("res://Sounds/Balloon_Pop.mp3", 7, 1.2)
	Funcs.color_explosion(0.55, 0.55, global_position, Funcs.get_bullets_node(), 0, false, Color.LIGHT_BLUE)

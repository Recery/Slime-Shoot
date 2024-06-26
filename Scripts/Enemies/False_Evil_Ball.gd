extends Enemy

@onready var sprite := get_node("Ball")
@onready var shading := get_node("Shading")

func _ready() -> void:
	sprite.frame = randi_range(0, 5)
	shading.frame = sprite.frame + 6
	
	if player.damage_collision != null:
		player.damage_collision.connect("body_entered", player_body_entered)

func _physics_process(_delta) -> void:
	if velocity != Vector2.ZERO:
		if velocity.x < 0:
			sprite.rotation -= float("0.0" + str(speed))
		else:
			sprite.rotation += float("0.0" + str(speed))

func _on_die() -> void:
	Funcs.particles(Vector2(2.5,2.5), global_position, Color.WHITE_SMOKE)

func _on_fade_timeout() -> void:
	shading.self_modulate.a -= 0.1
	
	if shading.self_modulate.a < 0.1: die.emit() # Si es muy transparente, que muera

func player_body_entered(body):
	# Al ser una ilusión, cuando el jugador lo toca desaparece esta ilusión
	if body == self:
		die.emit()

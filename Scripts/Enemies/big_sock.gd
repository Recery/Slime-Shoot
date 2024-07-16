extends Enemy

@onready var sprite := get_node("AnimatedSprite2D")

func _physics_process(_delta):
	sprite.flip_h = global_position.x < player.global_position.x

func _on_die():
	Funcs.regular_explosion(0.8, 0.8, global_position, Funcs.get_bullets_node(), 2, true)

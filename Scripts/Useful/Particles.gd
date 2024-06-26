extends Sprite2D

func _ready():
	await get_tree().create_timer(0.1).timeout
	for i in 10:
		modulate.a -= 0.1
		await get_tree().create_timer(0.08).timeout
		scale.x += 0.025
		scale.y += 0.025
	queue_free()

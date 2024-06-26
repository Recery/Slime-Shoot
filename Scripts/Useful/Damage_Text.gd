extends Label

func _ready():
	proceed()

func proceed():
	await get_tree().create_timer(1.2).timeout
	while modulate.a > 0.01:
		await get_tree().create_timer(0.1).timeout
		modulate.a -= 0.12
	queue_free()

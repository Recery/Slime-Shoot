extends Sprite2D

var insta_vanish

func _ready():
	await get_tree().create_timer(0.2).timeout
	for i in 10:
		modulate.a -= 0.1
		if !insta_vanish: await get_tree().create_timer(0.08).timeout
		scale.x += 0.05
		scale.y += 0.05
	queue_free()

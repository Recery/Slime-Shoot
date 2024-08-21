extends Enemy_Projectile

var wave_sprite := preload("res://Scenes/Enemies/SandstoneGolem/expansive_wave_sprite.tscn")
func _on_create_wave_timeout():
	var sprite := wave_sprite.instantiate()
	if Funcs.add_to_bullets(sprite):
		sprite.global_position = global_position
	else: sprite.queue_free()
	
	# Crear particulas en la onda expansiva
	for i in 5:
		var pos := global_position
		pos.y += 2
		pos.x += (i - 2) * 6
		Funcs.smoke_effect(Vector2(1.2,1.2), pos)
	
	await Funcs.fade_effect(sprite)
	sprite.queue_free()

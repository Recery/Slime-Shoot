extends Weapon

@onready var water := get_node("Water_Projectile") as Friendly_Projectile
@onready var effects_timer := get_node("Effects_Timer") as Timer
@onready var sound := get_node("Watering_Sound") as AudioStreamPlayer
@onready var collision := get_node("Water_Projectile/CollisionShape2D") as CollisionShape2D

func _extra_process() -> void:
	if flip_v: water.position.y = 0.5
	else: water.position.y = -0.5
	
	if not effects_timer.is_stopped() and not sound.playing:
		sound.play()

func _on_shoot() -> void:
	collision.disabled = false
	water.visible = true
	effects_timer.start()

func _on_effects_timer_timeout() -> void:
	collision.disabled = true
	water.visible = false

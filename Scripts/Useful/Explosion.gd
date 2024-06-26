extends AnimatedSprite2D

signal anim_ended

func _ready():
	play("explode")

func _on_animation_finished():
	emit_signal("anim_ended")
	queue_free()

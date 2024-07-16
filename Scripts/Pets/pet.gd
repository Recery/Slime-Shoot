extends Summon_Minion

@export var sprite : AnimatedSprite2D
@export var inverted_flip := false

func _physics_process(_delta):
	idle_pos = Vars.player.global_position
	
	idle_movement()
	
	if inverted_flip:
		sprite.flip_h = velocity.x > 0
	else:
		sprite.flip_h = velocity.x < 0

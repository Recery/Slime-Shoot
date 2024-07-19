extends Summon_Minion

@export var sprites : Array[Node]
@export var inverted_flip := false
@export var animation : AnimationPlayer

func _ready():
	animation.current_animation = "walk"

func _physics_process(_delta):
	idle_pos = Vars.player.global_position
	idle_pos.y += 10
	
	idle_movement()
	
	if inverted_flip:
		for sprite in sprites:
			sprite.flip_h = velocity.x > 0
	else:
		for sprite in sprites:
			sprite.flip_h = velocity.x < 0
	
	animation.speed_scale = max((velocity.length() + 10) / speed, 0.6)

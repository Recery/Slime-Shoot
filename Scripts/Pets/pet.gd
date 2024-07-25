extends Summon_Minion

@export var sprites : Array[Node]
@export var inverted_flip := false
@export var animation : AnimationPlayer

func _ready():
	animation.current_animation = "walk"

var extra_idle_pos_y := 0
func _physics_process(_delta):
	idle_pos = Vars.player.global_position
	if player.velocity.y > 0:
		extra_idle_pos_y = -10
	elif player.velocity.y < 0:
		extra_idle_pos_y = 10
	idle_pos.y += extra_idle_pos_y
	
	idle_movement()
	
	if inverted_flip:
		for sprite in sprites:
			sprite.flip_h = velocity.x > 0
	else:
		for sprite in sprites:
			sprite.flip_h = velocity.x < 0
	
	animation.speed_scale = max((velocity.length() + 10) / speed, 0.6)

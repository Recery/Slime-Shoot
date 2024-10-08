extends Summon_Minion
class_name Pet

@export var sprites : Array[Node]
@export var inverted_flip := false
@export var animation : AnimationPlayer

func _ready():
	add_to_group("Pet")
	
	if animation == null: return
	if animation.has_animation("walk"):
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
	
	if animation != null:
		animation.speed_scale = max((velocity.length() + 10) / speed, 0.6)

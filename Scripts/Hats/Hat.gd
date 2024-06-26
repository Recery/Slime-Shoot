extends Sprite2D

var anim : AnimationPlayer
var anim_slime : AnimationPlayer

## La posición a la que se mueve el sombrero cuando voltea el jugador.
## Si se deja en blanco, queda en la misma posicion de inicio y no cambia nunca.
@export var flip_offset := Vector2.ZERO

func _ready() -> void:
	anim = get_node("AnimationPlayer")
	anim_slime = get_parent().get_node("Animation_Player_Slime")
	
	anim_slime.connect("animation_started", set_animation)
 
func _physics_process(_delta) -> void:
	anim.speed_scale = anim_slime.speed_scale
	if Vars.player == null: return
	if Vars.player.get_viewport() == null or get_viewport() == null: return
	
	var local_mouse_pos := to_local(Vars.player.shoot_pos)
	flip_h = local_mouse_pos.x < 0
	
	if flip_offset != Vector2.ZERO and local_mouse_pos.x < 0:
		position = Vector2(-flip_offset.x, flip_offset.y)
	elif flip_offset != Vector2.ZERO:
		position = Vector2(flip_offset.x, flip_offset.y)

func set_animation(_name) -> void:
	anim.stop(true)
	anim.play("move_hat")

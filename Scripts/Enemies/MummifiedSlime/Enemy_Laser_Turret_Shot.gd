extends Enemy_Projectile

var pos_control : Node
var rotation_control : Node

func _ready():
	for i in range(3):
		await get_tree().create_timer(0.35).timeout
		particles()

func _physics_process(_delta):
	if pos_control == null or rotation_control == null: 
		visible = false
		return
	
	rotation = rotation_control.rotation
	global_position = pos_control.global_position
	visible = true

@onready var collision_shape = get_node("CollisionShape2D").shape
func particles():
	var segment_size : int = collision_shape.size.x / 10
	for i in range(10):
		var pos = to_global(Vector2(segment_size*i, 2))
		Funcs.particles(Vector2(1,1), pos, Color.RED)

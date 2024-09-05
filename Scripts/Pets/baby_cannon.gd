extends Pet

func _physics_process(_delta):
	idle_pos = player.global_position
	if player.velocity.y > 0:
		extra_idle_pos_y = -10
	elif player.velocity.y < 0:
		extra_idle_pos_y = 10
	idle_pos.y += extra_idle_pos_y
	
	idle_movement()
	graphics()

@onready var pivot := get_node("Center/Pivot")
@onready var cannon := get_node("Center/Pivot/Cannon")
@onready var wheel_1 := get_node("Wheel_1")
@onready var wheel_2 := get_node("Wheel_2")
func graphics() -> void:
	pivot.rotation = lerp_angle(pivot.rotation, velocity.angle(), 0.1)
	
	var weight_to_rotate := velocity.length() * 0.15
	if velocity.x > 0:
		cannon.flip_v = false
		if velocity != Vector2.ZERO:
			wheel_1.rotation_degrees += weight_to_rotate
			wheel_2.rotation_degrees += weight_to_rotate
		wheel_1.position.x = 1
		wheel_2.position.x = -2
	else:
		cannon.flip_v = true
		if velocity != Vector2.ZERO:
			wheel_1.rotation_degrees -= weight_to_rotate
			wheel_2.rotation_degrees -= weight_to_rotate
		wheel_1.position.x = -1
		wheel_2.position.x = 2

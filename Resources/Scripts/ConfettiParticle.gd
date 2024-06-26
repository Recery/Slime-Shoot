extends Resource
class_name ConfettiParticle

var confetti := Sprite2D.new()
var speed := randi_range(75, 125)
var dir := Vector2(randf_range(-1,1), randf_range(-1,1))

func _init() -> void:
	confetti.texture = load("res://Sprites/Useful/Confetti.png")
	
	match randi_range(0,3):
		0: confetti.modulate = Color.YELLOW
		1: confetti.modulate = Color.DEEP_SKY_BLUE
		2: confetti.modulate = Color.ORANGE_RED
		3: confetti.modulate = Color.GREEN
	
	confetti.rotation_degrees = randi_range(0, 360)

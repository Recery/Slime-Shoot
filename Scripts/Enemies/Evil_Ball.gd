extends Enemy

@onready var sprite := get_node("Ball")
@onready var shading := get_node("Shading")

func _ready() -> void:
	sprite.frame = randi_range(0, 5)
	shading.frame = sprite.frame + 6

func _physics_process(_delta) -> void:
	if velocity != Vector2.ZERO:
		if velocity.x < 0:
			sprite.rotation -= float("0.0" + str(speed))
		else:
			sprite.rotation += float("0.0" + str(speed))

func _on_die() -> void:
	Funcs.regular_explosion(0.8, 0.8, global_position, Vars.main_scene, 2, true)

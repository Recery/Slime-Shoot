extends Ability

@onready var use_sound := get_node("Use_Sound")
var vomit := preload("res://Scenes/Abilities/green_apple_vomit.tscn")
var green_apple := preload("res://Scenes/Abilities/green_apple.tscn")

func _on_activate():
	var apple_instance := green_apple.instantiate()
	apple_instance.name = "Rotten_Green_Apple"
	player.add_child(apple_instance)
	apple_instance.play("rotten")
	apple_instance.frame_changed.connect(_on_apple_frame_changed)

# Con cada frame simula una mordida de la manzana, cuando la termina de comer vomita
var frame_count := 0
func _on_apple_frame_changed():
	Funcs.sound_play("res://Sounds/Crunch.mp3", 20, 1.25)
	Funcs.particles(Vector2(1.5,1.5), player.global_position, Color.GREEN)
	if frame_count < 2:
		frame_count += 1
	elif player.has_node("Rotten_Green_Apple"):
		frame_count = 0
		player.get_node("Rotten_Green_Apple").queue_free()
		player_vomit()

func player_vomit():
	use_sound.play()
	var vomit_instance := vomit.instantiate()
	Funcs.add_to_bullets(vomit_instance)

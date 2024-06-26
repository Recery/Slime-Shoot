extends Enemy

@onready var sprite := get_node("Sprite2D")
func _physics_process(_delta) -> void:
	if velocity != Vector2.ZERO:
		if velocity.x < 0:
			sprite.rotation -= 0.05
		else:
			sprite.rotation += 0.05

@onready var spike := preload("res://Scenes/Enemies/cactus_spike.tscn")
func create_spikes():
	var number_of_spikes := randi_range(2,4)
	
	for i in range(number_of_spikes):
		var angle = i * (2 * PI / number_of_spikes)
		var x = global_position.x + randi_range(14,18) * cos(angle)
		var y = global_position.y + randi_range(14,18) * sin(angle)
		
		var spike_instance := spike.instantiate()
		Funcs.get_bullets_node().call_deferred("add_child", spike_instance)
		await spike_instance.child_entered_tree
		spike_instance.damage = damage - 4
		spike_instance.global_position = Vector2(x,y)

func _on_die():
	create_spikes()
	Funcs.regular_explosion(0.9, 0.9, global_position, Funcs.get_bullets_node(), 2, true)

extends Node2D

var confetti : Array[ConfettiParticle]
var end_time := 0.6

func _ready() -> void:
	var end_timer := Timer.new()
	add_child(end_timer)
	end_timer.connect("timeout", end_timeout)
	end_timer.start(end_time)
	
	Funcs.sound_play("res://Sounds/Party_Horn.mp3", -2, 1)
	
	for i in range(randi_range(25, 50)):
		confetti.append(ConfettiParticle.new())
		add_child(confetti[i].confetti)

func _physics_process(delta):
	for particle in confetti:
		particle.confetti.global_position += particle.dir * particle.speed * delta

func end_timeout() -> void:
	for particle in confetti:
		particle.dir = Vector2.DOWN
		particle.speed = 20
	await get_tree().create_timer(0.5).timeout
	for particle in confetti:
		Funcs.fade_effect(particle.confetti)
	await get_tree().create_timer(2).timeout
	queue_free()

extends Area2D

const speed = 450
const original_damage = 1
var damage

var direction
var damage_disabled
var despawn_timer

var generated_by : String

func _ready():
	damage = original_damage
	despawn_timer = get_node("DespawnTimer")
	despawn_timer.start()
	damage_disabled = false
	generated_by = "weapon"

func _physics_process(delta):
	if !damage_disabled:
		global_position += direction * speed * delta

func _on_body_entered(body):
	if !body.is_in_group("Player"):
		hide()
		if body.is_in_group("Enemies") && !damage_disabled:
			Funcs.deal_damage(body, damage)
		damage_disabled = true
		die()

func _on_despawn_timer_timeout():
	die()

func die():
	Funcs.regular_explosion(0.5, 0.5, global_position, Funcs.get_bullets_node(), 0, false)
	queue_free()

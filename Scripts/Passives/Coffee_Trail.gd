extends Friendly_Projectile

var coffee_debuff = preload("res://Scenes/Passives/coffee_debuff.tscn")
@onready var sprite = get_node("Sprite2D")

func _ready():
	sprite.frame = randi_range(0, 2)
	rotation = randi()

func _physics_process(_delta):
	scale.x += 0.001
	scale.y += 0.001

func _on_body_entered(body):
	if not body.is_in_group("Enemies") or stop_working: return
	
	if not body.is_in_group("Big_Enemies") and not body.is_in_group("Boss"):
		if not Funcs.has_node_in_group(body, "coffee_debuff"):
			stop_working = true
			body.add_child(coffee_debuff.instantiate())
			die.emit()

func _on_die():
	Funcs.fade_effect(sprite)

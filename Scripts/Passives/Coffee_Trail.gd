extends Friendly_Projectile

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
		if not body.has_node("Coffee_Debuff"):
			stop_working = true
			var buff := get_speed_buff()
			body.add_child(buff)
			buff.tree_exited.connect(func():
				if body != null:
					body.life = 0
					body.die.emit())
			die.emit()

func get_speed_buff() -> Buff_Speed_Enemy:
	var buff := Buff_Speed_Enemy.new()
	buff.weight_to_modify = 1.8
	buff.duration = 4
	buff.color = Color(0.6, 0.455, 0.361)
	buff.name = "Coffee_Debuff"
	return buff

func _on_die():
	Funcs.fade_effect(sprite)

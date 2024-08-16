extends Sprite2D
class_name Enemy_Weapon

@export var hold_offset := Vector2.ZERO

@export var cooldown := 2.0
var cooldown_timer : Timer
var can_shoot := true

@export var parent : Node
var can_rotate := true

signal shoot(alt_cooldown)
signal timed_shoot(time) ## A esta señal se le envia un tiempo (float) en segundos para que ejecute envie la señal de disparo despues de ese tiempo
signal recovered

func _ready():
	shoot.connect(_on_shoot)
	timed_shoot.connect(_on_timed_shoot)
	
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func _on_shoot(alt_cooldown := -1):
	can_shoot = false
	cooldown_timer.timeout.connect(func():
		can_shoot = true
		recovered.emit()
		)
	if alt_cooldown != -1:
		cooldown_timer.start(alt_cooldown)
	else: cooldown_timer.start(cooldown)

func _on_timed_shoot(time : float, alt_cooldown := -1):
	can_shoot = false
	await get_tree().create_timer(time).timeout
	shoot.emit(alt_cooldown)

func manage_rotation(angle = null):
	if not can_rotate: return
	
	if angle == null: Funcs.weapon_rotation(self, hold_offset, parent)
	elif angle is float or angle is int: Funcs.weapon_rotation(self, hold_offset, parent, angle)

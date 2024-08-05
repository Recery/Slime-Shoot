extends Enemy

@onready var sprite := get_node("AnimatedSprite2D")

var active := true

func _ready():
	life_module.take_damage.connect(_on_take_damage)

func _physics_process(_delta):
	sprite.flip_h = global_position.x > player.global_position.x

@onready var switch_state_timer := get_node("Switch_State_Timer")
func _on_switch_state_timer_timeout():
	active = not active
	immune = not active
	moving = active
	if not active: apply_new_speed()
	
	if active:
		sprite.animation = "walk_active"
		switch_state_timer.start(10)
	else:
		sprite.animation = "idle_not_active"
		switch_state_timer.start(6)

func _on_take_damage(damage_dealt):
	if active: return
	
	# Cuando no esta activo el daño hecho se cura
	life_module.heal(damage_dealt)

func _on_die():
	Funcs.regular_explosion(0.7, 0.7, global_position, Funcs.get_bullets_node(), 2, true)

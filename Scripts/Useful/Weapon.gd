extends Sprite2D
class_name Weapon

## El cooldown de disparo.
@export var shoot_cooldown := 0.5

## La energy que usa. 
@export var original_energy_use := 10.0
@onready var energy_use := original_energy_use

## El tiempo en que se empieza a recuperar energía después de usar el arma.
@export var energy_recover_cooldown := 1.0

## El offset que se usa para mostrar el arma en la mano del jugador.
@export var hold_offset := Vector2(7,0)

var can_shoot := true
var active := false
@export var rotation_activated := true
@onready var player := Vars.player

signal shoot

func _physics_process(_delta):
	if not active:
		hide()
		return
	else: show()
	
	if Input.is_action_pressed("shoot") && can_shoot:
		if player.reduce_energy(energy_use, energy_recover_cooldown): shoot.emit()
	
	if rotation_activated:
		Funcs.weapon_rotation(self, hold_offset)
	_extra_process()

func _extra_process(): pass

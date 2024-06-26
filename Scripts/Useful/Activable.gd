extends Area2D
class_name Activable

## La scale del sprite de la tecla f que se ve al acercarse.
@export var f_key_scale := Vector2(1,1)

var player_in_area := false
var player

var f_key : Sprite2D

signal activated(emitter : Area2D)

func _init() -> void:
	connect("body_entered", _when_body_entered)
	connect("body_exited", _when_body_exited)
	connect("ready", _when_ready)

func _when_ready() -> void:
	if Vars.player != null:
		player = Vars.player
	
	f_key = Sprite2D.new()
	add_child(f_key)
	f_key.texture = load("res://Sprites/Useful/FKey.png")
	f_key.global_position = global_position
	f_key.visible = false
	f_key.scale = f_key_scale

func _when_body_entered(body) -> void:
	if body == player:
		player_in_area = true
		if f_key != null: f_key.visible = true

func _when_body_exited(body) -> void:
	if body == player:
		player_in_area = false
		if f_key != null: f_key.visible = false

extends Node2D

@export var original_speed : float
@export var speed : float

func _ready():
	speed = original_speed

func set_original_speed(new_original_speed):
	original_speed = new_original_speed

func set_speed(new_speed):
	speed = new_speed

func reset_speed():
	speed = original_speed

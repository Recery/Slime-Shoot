@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends General_Buff
class_name Buff_Speed_Enemy

@export var weight_to_modify := 1.0

func _ready():
	affected_object = get_parent()
	if not affected_object is Enemy:
		printerr("Error: The affected object of this speed buff is not an enemy.")
		queue_free()
		return
	
	buff_application(self)

func buff_application(node):
	if not (node is Buff_Speed_Enemy or node is Knockback): return
	
	affected_object.speed *= weight_to_modify
	affected_object.apply_new_speed()
	print("Nueva velocidad aplicada por ", name, ": ", affected_object.speed)

func remove_buff():
	affected_object.speed = affected_object.base_speed
	affected_object.apply_new_speed()
	print("Velocidad reestablecida por ", name, ": ", affected_object.speed)

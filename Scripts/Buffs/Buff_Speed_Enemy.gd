@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends Buff
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
	
	if weight_to_modify == 0 and not affected_object.is_in_group("Full_Freezed"): 
		affected_object.add_to_group("Full_Freezed")
	
	affected_object.speed *= weight_to_modify
	affected_object.apply_new_speed()
	print("Nueva ", name, ": ", affected_object.speed)

func remove_buff():
	if weight_to_modify == 0 and affected_object.is_in_group("Full_Freezed"): 
		affected_object.remove_from_group("Full_Freezed")
	
	affected_object.speed = affected_object.base_speed
	affected_object.apply_new_speed()
	print("Reestablecida ", name, ": ", affected_object.speed)

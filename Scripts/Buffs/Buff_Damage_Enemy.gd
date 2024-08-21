@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends Buff
class_name Buff_Damage_Enemy

@export var weight_to_modify := 1.0

func _ready():
	affected_object = get_parent()
	if not affected_object is Enemy:
		printerr("Error: The affected object of this damage buff is not an enemy.")
		queue_free()
		return
	
	buff_application(self)

func buff_application(node):
	if not node is Buff_Damage_Enemy: return
	
	affected_object.damage *= weight_to_modify
	print("Nuevo daño: ", affected_object.damage)

func remove_buff():
	affected_object.damage = affected_object.base_damage
	
	print("Reestablecido daño: ", affected_object.damage)

@icon("res://Sprites/Buffs/BuffNodeIcon.png")
extends Buff
class_name Buff_Speed_Player

@export var weight_to_modify := 1.0

func _ready():
	affected_object = get_parent()
	if not affected_object is Player:
		printerr("Error: The affected object of this speed buff is not a player.")
		queue_free()
		return
	
	buff_application(self)

func buff_application(node):
	if not node is Buff_Speed_Player: return
	
	affected_object.speed *= weight_to_modify
	
	print("Velocidad: ", affected_object.speed)

func remove_buff():
	affected_object.speed = affected_object.original_speed

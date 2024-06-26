extends Control

func _on_weapons_button_pressed():
	activate("Weapons")

func _on_abilities_button_pressed():
	activate("Abilities")

func _on_passives_button_pressed():
	activate("Passives")

func _on_slimes_button_pressed():
	activate("Slimes")

func _on_hats_button_pressed():
	activate("Hats")

func activate(activated : String):
	get_node("Hats").hide()
	get_node("Slimes").hide()
	get_node("Passives").hide()
	get_node("Abilities").hide()
	get_node("Weapons").hide()
	get_node("Weapons_Button").disabled = false
	get_node("Abilities_Button").disabled = false
	get_node("Passives_Button").disabled = false
	get_node("Slimes_Button").disabled = false
	get_node("Hats_Button").disabled = false
	
	get_node(activated).show()
	get_node(activated + "_Button").disabled = true
	
	Funcs.sound_play("res://Sounds/uiclick.mp3", 20)

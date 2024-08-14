extends Control

var tips = [
"Remember to eat green apples daily!",
"Follow Ruby Muscaria on Twitch!",
"Pray for the Immortal Goldfish Goddess, or go to Slime Hell.",
"King Slime, you're a coward and traitor.",
"Terraria",
"World domeownation is near!",
"if player.is_playing: print('Thank you for playing!')",
"Have you fed your fish today?",
"Poo Slime, greatest slime ever.",
"What time is it? Maybe you should go to sleep now...",
"Frozen Bomber... Why are you so cute?",
"Scroll your mouse to change your weapon!",
"Read weapons descriptions in the weapon equipment tab!",
"Hold space to activate your slime perk!",
"What the hell can I say to surprise the player this time... Oh! You're here...",
"You can go fullscreen with F11!",
"Please support indie devs! By just playing our games you make us really happy.",
"Tired of grinding points? Not my problem. Keep grinding."
]

func _ready():
	get_node("Tip").text = tips.pick_random()
	
	if Vars.pet_equipped != null:
		get_node("Slime_With_Pet_Draw").add_child(Funcs.draw_equipped_slime(false, Vector2(2,2)))
		get_node("Pet_Draw").add_child(Funcs.draw_pet(false, Vector2(2,2)))
	else:
		get_node("Slime_Draw").add_child(Funcs.draw_equipped_slime(false, Vector2(2,2)))

var exiting := false
func _process(_delta):
	if exiting: return
	
	if get_parent().name == "Scene_Manager":
		if not get_parent().has_loading_screen:
			get_node("Camera2D").enabled = false
			exiting = true
			queue_free()

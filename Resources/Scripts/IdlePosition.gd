extends Resource
class_name IdlePosition

var pos := Vector2.ZERO
var used := false

	#for i in range(18):
	#	var angle = i * (2 * PI / 18)
	#	# 42.44 es el radio del circulo de la colision
	#	var x = global_position.x + 42.44 * cos(angle)
	#	var y = global_position.y + 42.44 * sin(angle)
	#	Funcs.particles(Vector2(1.2,1.2), Vector2(x,y), Color(0.882, 0.922, 1))

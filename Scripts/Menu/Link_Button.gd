extends TextureButton

@export var link : String

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	OS.shell_open(link)

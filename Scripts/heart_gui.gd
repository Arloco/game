extends Panel

@onready var _sprite: Sprite2D = $HeartFrames

# Called when the node enters the scene tree for the first time.
func _ready():
	print(_sprite)

func update(_whole: bool):

	if _whole:
		print("whole")
		_sprite.frame = 0  # full heart
	else:
		_sprite.frame = 1  # empty heart

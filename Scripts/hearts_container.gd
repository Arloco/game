extends HBoxContainer

@onready var HeartGuiClass = preload("res://Scenes/heart_gui.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

func updateHearts(current_health: int):
	var hearts = get_children()
	
	
	for i in range (Singleton.current_health):
		hearts[i].update(true)
	
	for i in range (Singleton.current_health, hearts.size()):
		hearts[i].update(false)

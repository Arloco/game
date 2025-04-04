extends Area2D
var door_open = false

@onready var heartsContainer = $/root/Inside/UI/HeartsContainer
@onready var player = $/root/Inside/Player

func _ready():
	print("new_scene")
	heartsContainer.setMaxHearts(Singleton.max_health)
	heartsContainer.updateHearts(Singleton.current_health)
	player.healthChanged.connect(heartsContainer.updateHearts)

func _process(delta):
	if door_open == true: 
		if Input.is_action_just_pressed("select"):
			get_tree().change_scene_to_file("res://Scenes/outside.tscn")

	
func _on_body_entered(body):
	if body.name == "Player":
		door_open = true
		print ("open")


func _on_body_exited(body):
	if body.name == "Player":
		door_open = false 
		print("closed")

extends Area2D
var door_open = false
var play = preload("res://Scenes/Inside_of_House.tscn") as PackedScene

func _process(delta):
	if door_open == true:
		if Input.is_action_just_pressed("select"):
			get_tree().change_scene_to_packed(play)
			
	
func _on_body_entered(body):
	if body.name == "Player":
		door_open = true
		print ("open")


func _on_body_exited(body):
	if body.name == "Player":
		door_open = false

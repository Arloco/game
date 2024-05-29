extends Area2D
var door_open = false

func _process(delta):
	if door_open == true:
		if Input.is_action_just_pressed("ui_select"):
			get_tree().change_scene_to_file("res://Inside_of_House.tscn")
			
	
func _on_body_entered(body):
	if body.name == "Player":
		door_open = true
		print ("open")


func _on_body_exited(body):
	if body.name == "Player":
		door_open = false

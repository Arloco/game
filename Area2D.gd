extends Area2D
var door_open = false


func _process(delta):
	print(door_open)
	if door_open == true:
		print("d") 
		if Input.is_action_pressed("ui_select"):
			get_tree().change_scene_to_file("res://Inside_of_House.tscn")
			print ("test2")
	
func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		door_open = true
		print ("test")


func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		door_open = false
		print ("test3")

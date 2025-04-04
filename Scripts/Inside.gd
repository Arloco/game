extends Area2D
var door_open = false

func _process(delta):
	if door_open == true and Singleton.boss_spawned == false: 
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

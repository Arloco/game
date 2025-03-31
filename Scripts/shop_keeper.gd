extends Node2D

var can_shop = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		if can_shop == true:
			print("shop is open")
			$Shop.visible = true

func _on_area_2d_body_entered(body = Node2D) -> void:
	if body.name == "Player":
		print("c")
		can_shop = true


func _on_area_2d_body_exited(body = Node2D) -> void:
	if body.name == "Player":
		can_shop = false

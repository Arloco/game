extends Node2D

var can_shop = false
var shop_open = false

func _process(delta: float) -> void:
	if not shop_open and Input.is_action_just_pressed("select"):
		if can_shop:  # No need for `== true`
			print("Shop is open")
			$Shop.visible = true
			get_tree().paused = true
			shop_open = true  # Update state

	elif shop_open and Input.is_action_just_pressed("select"):
		print("Shop closed")
		get_tree().paused = false
		$Shop.visible = false
		shop_open = false  # Update state


func _on_area_2d_body_entered(body = Node2D) -> void:
	if body.name == "Player":
		print("c")
		can_shop = true


func _on_area_2d_body_exited(body = Node2D) -> void:
	if body.name == "Player":
		can_shop = false

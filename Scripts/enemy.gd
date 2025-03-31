extends Area2D

var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$EnemyArt.flip_h = direction > 0
		
func _on_timer_timeout():
	direction *= -1


func _on_body_entered(body):
	if (body.name == "Player"):
		pass
	else:
		queue_free()

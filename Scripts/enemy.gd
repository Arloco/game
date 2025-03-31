extends Area2D

var direction = 1
@export var health = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$EnemyArt.flip_h = direction > 0
		
func _on_timer_timeout():
	direction *= -1


func _on_body_entered(body):
	if (body.name == "Player"):
		pass
	if body.is_in_group("Bullets"):
		print("yaya")
		health -= Singleton.bullet_damage
		if health <= 0:
			queue_free()

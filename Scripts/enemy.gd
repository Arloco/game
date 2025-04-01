extends Area2D

var direction = 1
@export var health = 10
var time

func _ready() -> void:
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$EnemyArt.flip_h = direction > 0
	time = delta
		
func _on_timer_timeout():
	direction *= -1


func _on_body_entered(body):
	if body.is_in_group("Bullets"):
		print("yaya")
		health -= Singleton.bullet_damage
		body.queue_free()
		if health <= 0:
			$AnimationPlayer.play("die")
			

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

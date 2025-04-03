extends Area2D

var direction = 1
@export var health = 20
@export var money_given_on_death = 10

@onready var hit_particles = $hit_particles
var time
var dead
func _ready() -> void:
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector2.RIGHT * direction)
	$EnemyArt.flip_h = direction > 0
	time = delta
	if dead == true:
		process_mode = 4
		
func _on_timer_timeout():
	direction *= -1
	
func start_particles():
	hit_particles.restart()  # Restart particles effect
	hit_particles.emitting = true  # Play particles


func _on_body_entered(body):
	if body.is_in_group("Bullets"):
		start_particles()
		print("yaya")
		health -= Singleton.bullet_damage
		body.queue_free()
		if health <= 0:
			Singleton.add_money(money_given_on_death)
			dead = true
			$AnimationPlayer.play("die")
			
		$EnemyArt.modulate = Color(255, 0, 0)  # Changes the sprite to red
		await get_tree().create_timer(0.1).timeout
		$EnemyArt.modulate = Color(1, 1, 1)  # Changes the sprite to normal

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()

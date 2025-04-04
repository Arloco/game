extends CharacterBody2D

@export var speed: float = 100.0  # Walking speed
@export var jump_force: float = -1000.0  # Jump strength
@export var gravity: float = 800.0  # Gravity strength
@export var leg_shrink_rate: float = 0.01  # How much legs shrink per hit

@onready var animator = $"AnimationPlayer"
@onready var player = $"/root/Inside/Player"  # Adjust path to player
@onready var jump_timer = $JumpTimer
@onready var right_leg = $"flipped/right leg"
@onready var left_leg = $"flipped/left leg"
@onready var body = $"flipped/body"
@onready var left_collision = $"flipped/damage zone/left leg collision"
@onready var right_collision = $"flipped/damage zone/right leg collision"
@onready var collision = $"bossy collision"
@onready var flipped = $flipped
@onready var collision1 = $"flipped/damage zone/CollisionShape2D2"
@onready var collision2 = $"flipped/damage zone/CollisionShape2D"
@onready var collision3 = $"flipped/damage zone/boss collision"
@export var jump_cooldown := 5.0   # Seconds between jumps

@export var jump_distance := 800.0  # How close to the player to trigger a jump

var leg_length: float = 0.18  # Initial leg length
@export var health: int = 400  # Boss health

var can_jump: bool = true  # Cooldown check

var multiplier = 1.0

var second_phase = false

var timed_out = false


func _physics_process(delta):
	if Singleton.boss_spawned == true:
		if Singleton.boss_spawning == true:
			animator.play("spawn")
			get_tree().paused = true
			print("th")
			await animator.animation_finished
			print("thee")
			get_tree().paused = false
			Singleton.boss_spawning = false
			
		else:
			print("theeeee")
			if not is_on_floor(): 
				velocity.y += gravity * delta
		
			# Move towards the player
			var direction = sign(player.global_position.x - global_position.x)
			velocity.x = direction * speed
			if velocity.x < 0:
				flipped.scale.x = -1
			if velocity.x > 0:
				flipped.scale.x = 1
				
			
			if second_phase == false:
				# Jump if close enough, on the ground, and not on cooldown
				var distance_to_player = global_position.distance_to(player.global_position)
				if distance_to_player <= jump_distance and is_on_floor() and can_jump:
					jump()

			move_and_slide()


func jump():
	velocity.y = jump_force
	can_jump = false  # Disable jumping

	# Start cooldown timer
	get_tree().create_timer(jump_cooldown).timeout.connect(_reset_jump)

func _reset_jump():
	can_jump = true  # Re-enable jumping after cooldown

func take_damage():
	if second_phase == false and Singleton.boss_spawning == false:
		modulate = Color(255, 0, 0)  # Changes the sprite to red
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1)  # Changes the sprite to normal
		
		print("d")
		leg_length -= leg_shrink_rate  # Shrink legs, but not too much
		left_leg.scale.y = leg_length  # Update sprite scale
		left_leg.position.y += leg_length*110* multiplier
		
		left_collision.scale.y = leg_length*5 # Update sprite scale
		left_collision.position.y += leg_length*140* multiplier
		
		right_leg.scale.y = leg_length  # Update sprite scale
		right_leg.position.y += leg_length*110* multiplier
		
		right_collision.scale.y = leg_length*5  # Update sprite scale
		right_collision.position.y += leg_length *140* multiplier
		
		collision.scale.y = leg_length*5  # Update sprite scale
		collision.position.y += leg_length *140* multiplier
		
		collision1.position.y += leg_length *210* multiplier
		collision2.position.y += leg_length *210* multiplier
		collision3.position.y += leg_length *210* multiplier
		
		body.position.y += leg_length * 240 * multiplier
		multiplier += 0.14
		print(left_leg.scale.y)
	elif second_phase == true:
		modulate = Color(255, 0, 0)  # Changes the sprite to red
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1)  # Changes the sprite to normal
		
		health -= Singleton.bullet_damage
		
	if left_leg.scale.y <= 0.03:
		speed = 300
		jump_force = -2000
		gravity = 1600
		jump_timer.start(1)
		second_phase = true
		
	if health <= 0:
		die()
	
func die():
	$/root/Inside/Player.SHAKE(200, 1)
	await get_tree().create_timer(1).timeout
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/end_screen.tscn")
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if Singleton.boss_spawned == true:
		if body.is_in_group("Player"):
			body.take_damage()  # Call player damage function if colliding
		if body.is_in_group("Bullets"):
			take_damage()
		if body.is_in_group("Lava"):
			die()


func _on_jump_timer_timeout() -> void:
	if is_on_floor() and timed_out == true or is_on_floor():
		velocity.y = jump_force  # Jump up
		await get_tree().create_timer(0.5).timeout  # Simulate air time
		velocity.y += gravity  # Fall faster toward player
		timed_out = false
	else:
		timed_out = true

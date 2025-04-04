extends CharacterBody2D

@export var speed: float = 100.0  # Walking speed
@export var jump_force: float = -1000.0  # Jump strength
@export var gravity: float = 800.0  # Gravity strength
@export var leg_shrink_rate: float = 2.0  # How much legs shrink per hit

@onready var player = $"/root/Inside/Player"  # Adjust path to player
@onready var jump_timer = $JumpTimer
@onready var sprite = $Sprite2D
@export var jump_cooldown := 5.0   # Seconds between jumps

@export var jump_distance := 800.0  # How close to the player to trigger a jump

var leg_length: float = 50.0  # Initial leg length
var health: int = 10  # Boss health

var can_jump: bool = true  # Cooldown check


func _ready():
	jump_timer.start()  # Start jumping periodically

func _physics_process(delta):
	if not is_on_floor() or is_on_player():  
		velocity.y += gravity * delta
		
	# Move towards the player
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * speed
		

	# Jump if close enough, on the ground, and not on cooldown
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player <= jump_distance and is_on_floor() and not is_on_player() and can_jump:
		jump()

	move_and_slide()
	
# Checks if the boss is standing on the player
func is_on_player() -> bool:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() == player:
			print("d")
			return true
	return false


func jump():
	velocity.y = jump_force
	can_jump = false  # Disable jumping

	# Start cooldown timer
	get_tree().create_timer(jump_cooldown).timeout.connect(_reset_jump)

func _reset_jump():
	can_jump = true  # Re-enable jumping after cooldown

func take_damage():
	print("d")
	health -= 1
	leg_length -= leg_shrink_rate  # Shrink legs, but not too much
	sprite.scale.y = leg_length / 50.0  # Update sprite scale

	if health <= 0:
		queue_free()  # Destroy boss when health is 0
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage()  # Call player damage function if colliding
	if body.is_in_group("Bullets"):
		take_damage()

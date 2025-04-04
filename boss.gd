extends CharacterBody2D

@export var speed: float = 100.0  # Walking speed
@export var jump_force: float = -400.0  # Jump strength
@export var gravity: float = 800.0  # Gravity strength
@export var leg_shrink_rate: float = 2.0  # How much legs shrink per hit

@onready var player = $"/root/Inside/Player"  # Adjust path to player
@onready var jump_timer = $JumpTimer
@onready var sprite = $Sprite2D

var leg_length: float = 50.0  # Initial leg length
var health: int = 100  # Boss health

func _ready():
	jump_timer.start()  # Start jumping periodically

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	# Move towards the player
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed

	# Move & Apply Physics
	move_and_slide()

func _on_JumpTimer_timeout():
	if player:
		velocity.y = jump_force  # Jump up
		await get_tree().create_timer(0.5).timeout  # Simulate air time
		velocity.y += gravity  # Fall faster toward player

func take_damage():
	health -= 1
	leg_length -= leg_shrink_rate  # Shrink legs, but not too much
	sprite.scale.y = leg_length / 50.0  # Update sprite scale

	if health <= 0:
		queue_free()  # Destroy boss when health is 0

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage()  # Call player damage function if colliding

extends CharacterBody2D

signal healthChanged

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -600.0
@export var jump_cutoff: float = 0.3  # Controls how much speed is cut off when releasing jump
@export var coyote_time: float = 0.15  # Time (seconds) player can still jump after leaving ground
@export var jump_buffer_time: float = 0.1  # Time (seconds) the jump input can be buffered

#health system
@onready var heartsContainer = $"../UI/HeartsContainer"
#@export var max_health = 2
#@onready var current_health: float = Singleton.max_health

var shoot_right = false
var shoot_left = false
@export var mana = 100
@export var regen_rate = 4
@export var bullet_speed = 1000
var flip = 1
var is_jumping = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var object=preload("res://Scenes/Bullet.tscn")

	
func _physics_process(delta):
	#print (Singleton.current_health)
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_timer -= delta  # Reduce coyote time when in air
	else:
		coyote_timer = coyote_time  # Reset coyote timer when touching ground
	
	# Buffer jump input
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time  # Store jump input

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta  # Reduce buffer time

		# Jump if we have coyote time left
		if coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			coyote_timer = 0  # Disable coyote time after jumping
			jump_buffer_timer = 0  # Reset jump buffer
			
	#makes it so we can reference mana from either the outside or the inside if mana_inside == false:
	$"../UI/ManaBar".value = mana

	# Jump cutoff when the button is released early
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	if direction > 0:
		flip = 1
	if direction < 0:
		flip = -1
	
	
	
	
	if mana < 100:
		mana += regen_rate*delta

	var instance = object.instantiate()
	
	if Input.is_action_just_pressed("shoot"):
		if mana >= 10:
			print("f")
			add_child(instance)

			if flip == 1:
				shoot_right = true
			if flip == -1:
				shoot_left = true
		
			
		
	if shoot_right == true:
		instance.linear_velocity.x = bullet_speed
		shoot_right = false
		mana -= 10
			
	if shoot_left == true:
		instance.linear_velocity.x = -bullet_speed
		instance.rotation = 820
		shoot_left = false
		mana -= 10
		
	if Singleton.current_health <= 0:
			Singleton.max_health = 2
			Singleton.current_health = Singleton.max_health
			healthChanged.emit(Singleton.current_health)
			get_tree().reload_current_scene()


func _on_enemy_body_entered(body):
	if (body.name == "Player"):
		Singleton.current_health -= 1
		healthChanged.emit(Singleton.current_health)
		print("hurt")
		velocity.y = -20
		
		
func _on_spring_body_entered(body):

	if (body.name == "Player"):
		velocity.y = -1225
	#print ("boing")

func _on_tall_shroom_body_entered(body):
	velocity.y = -1225
	#print ("boing")
	
	
func _on_roof_body_entered(body):
	velocity.y = -1225
	#print ("boing")
	


func _on_lava_area_body_entered(body):
	if (body.name == "Player"):
		Singleton.current_health -= 1
		healthChanged.emit(Singleton.current_health)
		print("hurt")
		position.y = -11
		position.x = -123
		if Singleton.current_health <= 0:
			get_tree().reload_current_scene()

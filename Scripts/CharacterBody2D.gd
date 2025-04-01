extends CharacterBody2D

signal healthChanged

@export var SPEED = 300.0

#Jump Vars
@export var JUMP_VELOCITY = -1000.0 #Jump Speed
@export var jump_cutoff: float = 0.3  # Controls how much speed is cut off when releasing jump
@export var coyote_time: float = 0.15  # Time (seconds) player can still jump after leaving ground
@export var jump_buffer_time: float = 0.1  # Time (seconds) the jump input can be buffered

@onready var camera = $Camera2D  # Camera

@onready var sprite = $Belinda

#health system
@onready var heartsContainer = $"../UI/HeartsContainer"

#Mana System Vars
@export var mana = 100
@export var regen_rate = 4
@export var bullet_speed = 1700

var shoot_right = false
var shoot_left = false
var flip = 1

var is_jumping = false
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@export var boingy_thing_bounce_speed = -1625

@export var gravity = 2000 #gravity

@onready var object=preload("res://Scenes/Bullet.tscn")

func _physics_process(delta):
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	Movement_and_grav(direction, delta)
	
	Mana_And_Weapon(direction, delta)
	
	Check_if_dead()
	
func Movement_and_grav(direction, delta):
	#GRAVITY#
	if not is_on_floor():
		if velocity.y > 0:  # Falling down
			velocity.y += gravity * 1.4 * delta  # Increase fall gravity
		else:  # Going up
			velocity.y += gravity * delta  # Reduce gravity slightly
		coyote_timer -= delta  # Reduce coyote time when in air
	else:
		coyote_timer = coyote_time  # Reset coyote timer when touching ground
	
	#JUMP#
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

	# Jump cutoff when the button is released early
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cutoff

	#MOVEMENT#
	if direction:
		velocity.x = direction * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func Check_if_dead():
	if Singleton.current_health <= 0:
		#die
		Singleton.max_health = 2
		Singleton.current_health = Singleton.max_health
		healthChanged.emit(Singleton.current_health)
		Singleton.apples_already_eaten.clear()
		get_tree().reload_current_scene()
			
func Mana_And_Weapon(direction, delta):
	#makes it so we can reference mana from either the outside or the inside if mana_inside == false:
	$"../UI/ManaBar".value = mana

	#make it so we can shoot even if not moving
	if direction > 0:
		flip = 1
	if direction < 0:
		flip = -1
	
	if mana < 100:
		mana += regen_rate*delta

	var instance = object.instantiate()
	
	#detecting input
	if Input.is_action_just_pressed("shoot"):
		if mana >= 10:
			add_child(instance)
			camera.start_shake(5)  # Small shake for shooting
			
			if flip == 1:
				shoot_right = true
			if flip == -1:
				shoot_left = true
		
	#shooting
	if shoot_right == true:
		instance.linear_velocity.x = bullet_speed
		shoot_right = false
		mana -= 10
			
	if shoot_left == true:
		instance.linear_velocity.x = -bullet_speed
		instance.rotation = 820
		shoot_left = false
		mana -= 10
			
func upgrade_weapon():
	if Singleton.money >= get_upgrade_cost():
		Singleton.money -= get_upgrade_cost()
		Singleton.weapon_level += 1
		Singleton.bullet_damage += 5
		print("Weapon upgraded! Level:", Singleton.weapon_level, " | Damage:", Singleton.bullet_damage)
	else:
		print("Not enough money!")

func get_upgrade_cost() -> int:
	return Singleton.weapon_level * 20

#checking for collisions
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		camera.start_shake(50)  # Shake intensity 10
		Singleton.current_health -= 1
		healthChanged.emit(Singleton.current_health)
		print("hurt")
		velocity.y = -20
		
	if area.is_in_group("boingy things"):
		velocity.y = boingy_thing_bounce_speed
	
	if area.is_in_group("Lava"):
		Singleton.current_health -= 1
		healthChanged.emit(Singleton.current_health)
		print("hurt")
		position.y = -11
		position.x = -123
		
	

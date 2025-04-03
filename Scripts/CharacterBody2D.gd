extends CharacterBody2D

signal healthChanged

@export var SPEED = 500.0

#Jump Vars
@export var JUMP_VELOCITY = -1500.0 #Jump Speed
@export var jump_cutoff: float = 0.05  # Controls how much speed is cut off when releasing jump
@export var coyote_time: float = 0.15  # Time (seconds) player can still jump after leaving ground
@export var jump_buffer_time: float = 0.1  # Time (seconds) the jump input can be buffered

@onready var camera = $Camera2D  # Camera

@onready var sprite = $Belinda

@onready var jump_particles = $"jump particles"

#health system
@onready var heartsContainer = $"../UI/HeartsContainer"

@onready var animator = $"AnimationPlayer"

#Mana System Vars
@export var mana = 10000
@export var regen_rate = 4
@export var bullet_speed = 1700

var shoot_right = false
var shoot_left = false
var flip = 1
var dead = false

@export var max_jumps: int = 2  # Allows for double jump (set to 3 for triple jump!)

var jumps_left = max_jumps  # Track remaining jumps

@export var acc =40

var is_falling
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@export var boingy_thing_bounce_speed = -1825

@export var gravity = 3000 #gravity

@onready var object=preload("res://Scenes/Bullet.tscn")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	Movement_and_grav(direction, delta)
	
	if dead == false:
		Mana_And_Weapon(direction, delta)
	
		Check_if_dead()
	
	#make camera better after death
	else:
		camera.position = position
	
func Movement_and_grav(direction, delta):
	#GRAVITY#
	if not is_on_floor():
		#when player is at peak of jump slow down gravity and speed up acceleration
		if velocity.y <= 10 and velocity.y >= -10:
			print("peak")
			velocity.y += gravity * 0.4 * delta
		elif velocity.y > 0:  # Falling down
			is_falling = true
			velocity.y += gravity * 1.4 * delta  # Increase fall gravity
		else:  # Going up
			velocity.y += gravity * 0.9 * delta  # Reduce gravity slightly
		coyote_timer -= delta  # Reduce coyote time when in air
	else:
		coyote_timer = coyote_time  # Reset coyote timer when touching ground

	if dead == false:
		#JUMP#
		# Buffer jump input
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer = jump_buffer_time  # Store jump input

		if jump_buffer_timer > 0:
			jump_buffer_timer -= delta  # Reduce buffer time
			# Jump if we have coyote time left
			if coyote_timer > 0 or Input.is_action_just_pressed("jump") and jumps_left > 0:
				jump_particles.restart()  # Restart particles effect
				jump_particles.emitting = true  # Play particles
				animator.play("Jump")
				velocity.y = JUMP_VELOCITY
				jumps_left -= 1  # Use one jump
				coyote_timer = 0  # Disable coyote time after jumping
				jump_buffer_timer = 0  # Reset jump buffer

		# Jump cutoff when the button is released early
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= jump_cutoff
			
		
		if is_falling == true:
			if is_on_floor():
				animator.play("land on ground")
				is_falling = false
				jumps_left = max_jumps #resets double jump
			
		#MOVEMENT#
		if Input.is_action_pressed("ui_right"):
			if velocity.x < 0:
				velocity.x = lerp(velocity.x, 0.0, 1)
			velocity.x = min(velocity.x + acc, SPEED)
		elif Input.is_action_pressed("ui_left"):
			if velocity.x > 0:
				velocity.x = lerp(velocity.x, 0.0, 1)
			velocity.x = max(velocity.x - acc, -SPEED)
		elif not is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, 0.1)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.7)
	 
	move_and_slide()


#any thing you want to happen immediatly when they die
func Check_if_dead():
	if Singleton.current_health <= 0:
		dead = true
		animator.play("Death")

#reseting values and respawing player
func die():
	Singleton.max_health = 2
	Singleton.current_health = Singleton.max_health
	healthChanged.emit(Singleton.current_health)
	Singleton.apples_already_eaten.clear()
	get_tree().reload_current_scene()

#after death animation finishes reload scene
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		die()

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
			velocity.y = 0
			
			if flip == 1:
				shoot_right = true
			if flip == -1:
				shoot_left = true
		
	#shooting
	if shoot_right == true:
		instance.linear_velocity.x = bullet_speed
		shoot_right = false
		mana -= 10
		if is_on_floor():
			velocity.x -= 1000
		else:
			velocity.x -= 100
			
	if shoot_left == true:
		instance.linear_velocity.x = -bullet_speed
		instance.rotation = 820
		shoot_left = false
		mana -= 10
		if is_on_floor():
			velocity.x += 1000
		else:
			velocity.x += 100


func upgrade_weapon():
	if Singleton.spend_money(get_upgrade_cost()):
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
		if jumps_left == 0:
			jumps_left += 1
	
	if area.is_in_group("Lava"):
		Singleton.current_health -= 1
		healthChanged.emit(Singleton.current_health)
		print("hurt")
		if Singleton.current_health > 0:
			position.y = -11
			position.x = -123
		else:
			Check_if_dead()

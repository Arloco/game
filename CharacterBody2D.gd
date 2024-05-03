extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var shoot_right = false
var shoot_left = false
@export var mana = 100
@export var regen_rate = 4
@export var bullet_speed = 1000
var flip = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var object=preload("res://area_2d.tscn")


	
func _physics_process(delta):
	print (mana)
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	#makes it so we can reference mana from either the outside or the inside if mana_inside == false:
	$Camera2D/HScrollBar.value = mana
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	
	
	var instance = object.instantiate()
	
	if mana < 100:
		mana += regen_rate*delta

		
	
	
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




func _on_enemy_body_entered(body):
	print ("dead")
	get_tree().reload_current_scene()
	

func _on_spring_body_entered(body):
	velocity.y = -1000
	print ("boing")



func _on_tall_shroom_body_entered(body):
	velocity.y = -1000
	print ("boing")

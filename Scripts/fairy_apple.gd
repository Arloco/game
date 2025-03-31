extends Area2D
@onready var player = $"../Player"
@onready var heartsContainer = $"../UI/HeartsContainer"
@onready var heartFrames = $HeartFrames
@onready var hearts_container = $"."
signal fairyAppleHealthChanged
@export var apple_number: int
# Called when the node enters the scene tree for the first time.
func _ready():
	if apple_number in Singleton.apples_already_eaten:
		queue_free()


func _on_body_entered(body):
	if (body.name == "Player"):
		Singleton.max_health += 1
	Singleton.current_health = Singleton.max_health
	heartsContainer.setMaxHearts(1)
	fairyAppleHealthChanged.emit(Singleton.current_health)
	Singleton.apples_already_eaten.append(apple_number)
	print (Singleton.max_health)
	queue_free()

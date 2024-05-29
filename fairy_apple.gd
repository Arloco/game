extends Area2D
@onready var player = $"../Player"
@onready var heartsContainer = $"../UI/HeartsContainer"
@onready var heartFrames = $HeartFrames
@onready var hearts_container = $"."
signal fairyAppleHealthChanged
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (body.name == "Player"):
		player.max_health += 1
	player.current_health = player.max_health
	heartsContainer.setMaxHearts(1)
	fairyAppleHealthChanged.emit(player.current_health)
	print (player.max_health)
	queue_free()

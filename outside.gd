extends Node2D

@onready var heartsContainer = $UI/HeartsContainer
@onready var player = $Player
@onready var fairyApple = $FairyApple
@onready var fairyApple2 = $FairyApple2
@onready var fairyApple3 = $FairyApple3
# Called when the node enters the scene tree for the first time.
func _ready():
	heartsContainer.setMaxHearts(Singleton.max_health)
	heartsContainer.updateHearts(Singleton.current_health)
	player.healthChanged.connect(heartsContainer.updateHearts)
	fairyApple.fairyAppleHealthChanged.connect(heartsContainer.updateHearts)
	fairyApple2.fairyAppleHealthChanged.connect(heartsContainer.updateHearts)
	fairyApple3.fairyAppleHealthChanged.connect(heartsContainer.updateHearts)

# Called every frame. 'delta' is the elapsed time since th previous frame.
func _process(delta):
	pass

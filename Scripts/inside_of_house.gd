extends Node2D
@onready var heartsContainer = $/root/Inside/Control/UI/HeartsContainer
@onready var player = $/root/Inside/Player

func _ready():
	print("new_scene")
	heartsContainer.setMaxHearts(Singleton.max_health)
	heartsContainer.updateHearts(Singleton.current_health)
	player.healthChanged.connect(heartsContainer.updateHearts)

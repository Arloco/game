extends Control

@onready var player = $/root/Inside/Player  # Reference the Player node
@onready var upgrade_cost_label = $"upgrade cost"
@onready var buy_button = $"Buy button"
var boss_scene = preload("res://Scenes/boss.tscn")

func _ready():
	update_ui()
	if Singleton.boss_spawned == true:
		spawn_boss()

func update_ui():
	upgrade_cost_label.text = "Upgrade Cost: $" + str(player.get_upgrade_cost())

func _on_buy_button_pressed():
	if Singleton.weapon_level >= 5:
		spawn_boss()

	
	
	player.upgrade_weapon()
	update_ui()
	
func spawn_boss():
	print("boss spawning")
	get_tree().paused = false
	visible = false
	$"/root/Inside/Shop Keeper".visible = false
	$"/root/Inside/boss".visible = true
	$"/root/Inside/Player".SHAKE(200, 1.5)
	Singleton.boss_spawned = true
	Singleton.boss_spawning = true
	
	

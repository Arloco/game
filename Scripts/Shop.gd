extends Control

@onready var player = $/root/Inside/Player  # Reference the Player node
@onready var upgrade_cost_label = $"upgrade cost"
@onready var buy_button = $"Buy button"
var boss_scene = preload("res://Scenes/boss.tscn")

func _ready():
	update_ui()

func update_ui():
	upgrade_cost_label.text = "Upgrade Cost: $" + str(player.get_upgrade_cost())

func _on_buy_button_pressed():
	if Singleton.weapon_level >= 5:
		print("gogogo")
		get_tree().paused = false
		Singleton.boss_spawned = true
		visible = false
		$"/root/Inside/Shop Keeper".visible = false
	
	player.upgrade_weapon()
	update_ui()

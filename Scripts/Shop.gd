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
	$"/root/Inside/Player".position.x += -240
	get_tree().paused = false
	visible = false
	$"/root/Inside/Player".SHAKE(200, 2)
	Singleton.boss_spawned = true
	Singleton.boss_spawning = true
	await get_tree().create_timer(1.6).timeout
	$"/root/Inside/Shop Keeper".visible = false
	$"/root/Inside/boss".visible = true

	
	

extends Control

@onready var player = $/root/Inside/Player  # Reference the Player node
@onready var weapon_cost_label = $"Weapon cost"
@onready var mana_cost_label = $"mana cost"
var boss_scene = preload("res://Scenes/boss.tscn")

func _ready():
	update_ui()
	if Singleton.boss_spawned == true:
		spawn_boss()

func update_ui():
	weapon_cost_label.text = "Upgrade Cost: $" + str(player.get_upgrade_cost())
	mana_cost_label.text = "Mana Cost: $" + str(player.get_mana_upgrade_cost())

	
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

	

func _on_weapon_button_pressed() -> void:
	if Singleton.weapon_level >= 5:
		spawn_boss()

	player.upgrade_weapon()
	update_ui()


func _on_mana_button_pressed() -> void:
	player.upgrade_mana()
	update_ui()

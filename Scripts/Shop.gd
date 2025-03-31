extends Control

@onready var player = $/root/Inside/Player  # Reference the Player node
@onready var currency_label = $money
@onready var upgrade_cost_label = $"upgrade cost"
@onready var buy_button = $"Buy button"

func _ready():
	update_ui()

func update_ui():
	currency_label.text = "Money: $" + str(Singleton.money)
	upgrade_cost_label.text = "Upgrade Cost: $" + str(player.get_upgrade_cost())

func _on_buy_button_pressed():
	player.upgrade_weapon()
	update_ui()

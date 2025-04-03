extends Label

func _ready():
	# Connect to money_changed signal
	Singleton.money_changed.connect(update_money)
	# Set initial value
	update_money(Singleton.money)

func update_money(new_amount):
	text = "Money: $" + str(new_amount)  # Update label text

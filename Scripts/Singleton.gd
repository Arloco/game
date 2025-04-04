extends Node

var max_health = 2
@onready var current_health: float = Singleton.max_health
var apples_already_eaten = []
var bullet_damage = 10
var money = 1000
var weapon_level = 1
var boss_spawned = false

signal money_changed(new_amount)  # Signal for UI updates

func _ready() -> void:
	add_money(0)

func add_money(amount: int):
	money += amount
	money_changed.emit(money)  # Notify UI

func spend_money(amount: int):
	if money >= amount:
		money -= amount
		money_changed.emit(money)  # Notify UI
		return true  # Purchase successful
	return false  # Not enough money

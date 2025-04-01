extends Node

var max_health = 2
@onready var current_health: float = Singleton.max_health
var apples_already_eaten = []
var bullet_damage = 10
var money = 10000
var weapon_level = 1

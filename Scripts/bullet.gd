extends RigidBody2D

func _ready() -> void:
	modulate.s = Singleton.bullet_red
	add_to_group("Bullets")

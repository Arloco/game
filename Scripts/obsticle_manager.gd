extends Node

@onready var player = get_node("/root/World/Player")  # Adjust this path!

var load_distance = 1300

func _process(delta):
	for obj in get_children():
		if not obj.has_method("set_process"):
			continue  # skip nodes that don't support this

		var dist = obj.global_position.distance_to(player.global_position)
		var should_be_active = dist < load_distance

		obj.visible = should_be_active
		obj.set_process(should_be_active)

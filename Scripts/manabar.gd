extends HScrollBar

func _process(delta: float) -> void:
	if max_value != Singleton.max_mana:
		max_value = Singleton.max_mana

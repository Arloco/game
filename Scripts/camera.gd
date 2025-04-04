extends Camera2D

var shake_intensity: int = 0
var shake_decay: int = 5 # How fast the shake fades
var rng = RandomNumberGenerator.new()
signal done

func _process(delta):
	if shake_intensity > 0:
		# Generate a small random offset
		offset = Vector2(
			rng.randf_range(-shake_intensity, shake_intensity), 
			rng.randf_range(-shake_intensity, shake_intensity)
		)
		shake_intensity = lerp(shake_intensity, 0, shake_decay * delta)  # Reduce shake over time
	else:
		offset = Vector2.ZERO  # Reset when done
		emit_signal("done")
		

func start_shake(intensity, decay):
	shake_intensity = intensity
	shake_decay = decay

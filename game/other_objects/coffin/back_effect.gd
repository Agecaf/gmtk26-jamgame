extends Sprite2D

@onready var back_effect: Sprite2D = %BackEffect


var t = 0.0

func _process(delta: float) -> void:
	
	# Update graphics
	t += delta
	var lambda = 0.5 * sin(t * PI) + 0.5
	var gradient: Gradient = (back_effect.texture as GradientTexture2D).gradient
	gradient.set_offset(1, lerpf(0.3, 0.35, lambda))
	gradient.set_offset(2, lerpf(0.4, 0.5, lambda))
	

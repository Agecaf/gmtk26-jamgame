extends Node2D

@onready var sprite: Sprite2D = %Sprite

var t = 0.0
func _process(delta: float) -> void:
	t += delta
	sprite.frame = posmod(floor(t * 5.0), 6)
	sprite.position.y = round(sin(t * TAU / 2) * 0.8)

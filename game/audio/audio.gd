class_name Audio extends Node2D

# Initialization
func _ready() -> void:
	# Register
	Game.audio = self

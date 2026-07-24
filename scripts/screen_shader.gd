extends Node2D

func _process(_delta: float) -> void:
	(material as ShaderMaterial).set_shader_parameter(&"time_left", Game.countdown.time_left)
	

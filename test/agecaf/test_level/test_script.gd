extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SFX.play(SFX.JUMP)
		print("Play!")

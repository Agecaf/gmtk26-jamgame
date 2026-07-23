extends Control

func _process(delta: float) -> void:
	# Return if not active
	if not visible: return
	
	# Check for player input
	if Input.is_action_just_pressed("ui_accept"):
		Game.menu.go_to(&"GameMenu")

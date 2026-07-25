extends Control

@onready var continue_button: Button = %Continue
@onready var return_to_main_button: Button = %ReturnToMain

func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	# Connect
	continue_button.pressed.connect(continue_callback)
	return_to_main_button.pressed.connect(Game.menu.go_to.bind(&"MainMenu"))

func start():
	# On Victory
	if Game.victory:
		continue_button.text = "Continue"
		
		# Save score
		Game.max_fruits[Game.level_index] = max(Game.fruits, Game.max_fruits[Game.level_index])
		Game.max_level = max(Game.max_level, Game.level_index + 1)
		
		# Increase level index
		Game.level_index += 1
	
	# Game defeat
	else:
		continue_button.text = "Retry"

func continue_callback() -> void:
	
	# If On victory
	if Game.victory:
		if Game.level_index >= len(Game.container.levels):
			Game.level_index = 0
			Game.menu.go_to(&"MainMenu")
		else:
			Game.menu.go_to(&"PreLevelMenu")
	# Retry
	else:
		Game.menu.go_to(&"GameMenu")


#

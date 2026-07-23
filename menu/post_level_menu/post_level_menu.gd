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
	# If Game.victory
	if false:
		continue_button.text = "Continue"
	else:
		continue_button.text = "Retry"

func continue_callback() -> void:
	
	# If Game.victory
	if false:
		Game.menu.go_to(&"PreLevelMenu")
	# Retry
	else:
		Game.menu.go_to(&"GameMenu")


#

extends Control

@onready var continue_button: Button = %Continue
@onready var return_to_main_button: Button = %ReturnToMain
@onready var settings_button: Button = %Settings

func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	# Connect
	continue_button.pressed.connect(Game.menu.go_to.bind(&"GameMenu"))
	return_to_main_button.pressed.connect(Game.menu.go_to.bind(&"MainMenu"))
	settings_button.pressed.connect(Game.menu.go_to.bind(&"SettingsMenu"))


# Pause the game
func start() -> void:
	# Pause
	get_tree().paused = true

# End the pause
func end() -> void:
	# Returning to main menu
	if Game.menu.next_menu_name == &"MainMenu":
		get_tree().paused = false
		Game.game_end.emit()
	
	# Returning to game
	if Game.menu.next_menu_name == &"GameMenu":
		get_tree().paused = false

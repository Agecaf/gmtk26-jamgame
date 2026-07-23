extends Control

@onready var return_button: Button = %Return

func _ready() -> void:
	return_button.pressed.connect(return_to_previous)

func return_to_previous() -> void:
	Game.menu.go_to(Game.menu.previous_menu_name)


func start() -> void:
	if Game.menu.previous_menu_name == &"MainMenu":
		return_button.text = "Return to Main Menu"
	if Game.menu.previous_menu_name == &"PauseMenu":
		return_button.text = "Return to Pause Menu"

extends Control

@onready var pause_button: Button = %Pause

func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	pause_button.pressed.connect(Game.menu.go_to.bind(&"PauseMenu"))

# Check if we need to start a new level, or if we're just returning from pause
func start() -> void:
	if Game.menu.previous_menu_name == &"PreLevelMenu":
		Game.container.load_level()

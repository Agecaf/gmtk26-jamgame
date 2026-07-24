extends Control

@onready var pause_button: Button = %Pause

func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	pause_button.pressed.connect(Game.menu.go_to.bind(&"PauseMenu"))
	Game.countdown.timeout.connect(Game.menu.go_to.bind(&"PostLevelMenu"))

# Check if we need to start a new level, or if we're just returning from pause
func start() -> void:
	# New level or retry
	if Game.menu.previous_menu_name in [&"PreLevelMenu", &"PostLevelMenu"]:
		Game.container.load_level()
		Game.audio.game_music.play()
		Game.countdown.start(60)
	
	
	# Unpause
	if Game.menu.previous_menu_name == &"PauseMenu":
		pass

func end() -> void:
	# Stop the music unless we're just pausing the game.
	if Game.menu.next_menu_name != &"PauseMenu":
		Game.audio.game_music.stop()
		Game.countdown.stop()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"pause"):
		Game.menu.go_to(&"PauseMenu")

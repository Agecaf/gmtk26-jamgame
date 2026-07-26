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
	Game.audio.game_music.stream_paused = true
	
	if Game.menu.previous_menu_name != &"SettingsMenu":
		Game.audio.prelevel_music.play()

# End the pause
func end() -> void:
	# Returning to main menu
	if Game.menu.next_menu_name == &"MainMenu":
		get_tree().paused = false
		Game.audio.game_music.stream_paused = false
		Game.game_end.emit()
		Game.audio.game_music.stop()
		Game.countdown.stop()
		Game.audio.prelevel_music.stop()
	
	# Returning to game
	if Game.menu.next_menu_name == &"GameMenu":
		get_tree().paused = false
		Game.audio.game_music.stream_paused = false
		Game.audio.prelevel_music.stop()

func _process(_delta: float) -> void:
	if Game.menu.current_menu.name == &"GameMenu":
		if Input.is_action_just_pressed(&"pause"):
			Game.menu.go_to(&"PauseMenu")
	elif Game.menu.current_menu == self:
		if Input.is_action_just_pressed(&"pause"):
			Game.menu.go_to(&"GameMenu")

extends Control

@onready var new_game_button = %NewGame
@onready var level_select_button = %LevelSelect
@onready var settings_button = %Settings

# Initialization
func _ready() -> void:
	# Need to wait for parent to register
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	# Connect signals
	level_select_button.pressed.connect(Game.menu.go_to.bind(&"LevelSelectMenu"))
	new_game_button.pressed.connect(new_game)
	settings_button.pressed.connect(Game.menu.go_to.bind(&"SettingsMenu"))
	


func new_game() -> void:
	Game.menu.go_to(&"PreLevelMenu")

# Start
func start() -> void:
	# No need to start the music menu in this case.
	if Game.menu.previous_menu_name in [&"SettingsMenu", &"LevelSelectMenu"]:
		pass
	
	# Start the menu music
	else:
		Game.audio.menu_music.play()

# End menu music
func end() -> void:
	# No need to start the music menu in this case.
	if Game.menu.next_menu_name in [&"SettingsMenu", &"LevelSelectMenu"]:
		pass
	
	# Start the menu music
	else:
		Game.audio.menu_music.stop()

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


func new_game() -> void:
	Game.menu.go_to(&"PreLevelMenu")

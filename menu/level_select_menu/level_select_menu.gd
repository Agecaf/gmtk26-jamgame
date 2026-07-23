class_name LevelSelectMenu extends Control

@onready var return_button: Button = %Return
@onready var level_buttons: GridContainer = %LevelButtons

# Initialize
func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	# Connect
	return_button.pressed.connect(Game.menu.go_to.bind(&"MainMenu"))
	
	# Add buttons
	for idx in len(Game.container.levels):
		var button: Button = Button.new()
		button.text = "Level %d" % idx
		button.custom_minimum_size = Vector2(400, 100)
		level_buttons.add_child(button)
		button.pressed.connect(choose_level.bind(idx))

func choose_level(level_index: int) -> void:
	Game.level_index = level_index
	Game.menu.go_to(&"PreLevelMenu")
	pass

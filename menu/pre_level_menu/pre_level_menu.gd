extends Control

@onready var story_text: RichTextLabel = %StoryText
@onready var continue_button: Button = %Continue


func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred():
	continue_button.pressed.connect(Game.menu.go_to.bind(&"GameMenu"))


func start() -> void:
	if Game.level_index >= 0 and Game.level_index < len(Game.container.start_text):
		story_text.text = Game.container.start_text[Game.level_index]
	pass

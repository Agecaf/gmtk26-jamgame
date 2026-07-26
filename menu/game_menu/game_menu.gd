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
	
	# Pause button
	pause_button.text = "Pause [%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"pause")[0].physical_keycode).to_lower()

func end() -> void:
	# Stop the countdown if moving to post level menu.
	if Game.menu.next_menu_name != &"PauseMenu":
		Game.countdown.stop()

func _process(_delta: float) -> void:
	if Game.menu.current_menu != self: return
	
	if Input.is_action_just_pressed(&"retry"):
		retry.call_deferred()
		

func retry() -> void:
	Game.pocketwatch.close()
	Game.black_frame.target_alpha = 1.0
	await get_tree().create_timer(0.3).timeout
	Game.container.load_level()
	Game.audio.game_music.play()
	Game.countdown.start(60)
	await get_tree().create_timer(0.1).timeout
	Game.black_frame.target_alpha = 0.0
	

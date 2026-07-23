class_name GameScene extends Node2D


# Initialization
func _ready() -> void:
	# Register
	Game.scene = self

	# Start the countdown (for testing: react to its signals with debug messages)
	add_child(Countdown.new())

	Game.countdown.tick.connect(
		func(sec_left):
			Debug.info('Tick. (%ds left)' % [sec_left])
	)
	Game.countdown.timeout.connect(
		func():
			Debug.warning('Time\'s up!')
	)

	Game.countdown.set_timer(3)
	
	# For testing purposes; if this is the root scene, call game_start
	# Only happens when you "Run Current Scene" on the game_scene
	if self.get_parent() == get_tree().root:
		Game.game_start.emit.call_deferred()

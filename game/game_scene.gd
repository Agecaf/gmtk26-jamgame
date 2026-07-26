class_name GameScene extends Node2D


# Initialization
func _ready() -> void:
	# Register
	Game.scene = self
	
	# Initialize
	Game.victory = false
	Game.fruits = 0
	
	# For testing purposes; if this is the root scene, call game_start
	# Only happens when you "Run Current Scene" on the game_scene
	if self.get_parent() == get_tree().root:
		Game.game_start.emit.call_deferred()
		
		# Start the countdown (Otherwise started by GameMenu)
		Game.countdown.start(60)
		Game.countdown.tick.connect(
			func(sec_left):
				Debug.info('Tick. (%ds left)' % [sec_left])
		)

		Game.coffin_sequence_complete.connect(
			func():
				Debug.info('Congratulations, you made it!')
		)

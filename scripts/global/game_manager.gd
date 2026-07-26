extends Node
# Auto load as Game

# Signals
@warning_ignore("unused_signal") signal game_start()
@warning_ignore("unused_signal") signal game_end()

# Links to core elements of the game
var audio: AudioClass
var scene: GameScene
var player: Player
var camera: PlayerCamera
var countdown: Countdown
var menu: Menu
var container: GameContainer
var pocketwatch: PocketWatch
var black_frame: BlackFrame

# Used to choose the level
var level_index: int = 0

# Progression
var max_level: int = 0
var max_fruits: Array[int] = []
var victory: bool = false
var fruits: int = 0

# Initialization
func _ready() -> void:
	# Add the game countdown.
	countdown = Countdown.new()
	add_child(countdown)

extends Node
# Auto load as Game

# Signals
@warning_ignore("unused_signal") signal game_start()
@warning_ignore("unused_signal") signal game_end()

# Links to core elements of the game
var audio: Audio
var scene: GameScene

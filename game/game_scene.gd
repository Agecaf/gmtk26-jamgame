class_name GameScene extends Node2D

# Initialization
func _ready() -> void:
	# Register
	Game.scene = self
	
	# For testing purposes; if this is the root scene, call game_start
	# Only happens when you "Run Current Scene" on the game_scene
	if self.get_parent() == get_tree().root:
		Game.game_start.emit.call_deferred()

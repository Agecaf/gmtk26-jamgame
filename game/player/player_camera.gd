class_name PlayerCamera extends Camera2D

# Constants
var CAMERA_SPEED = 10.0


# This camera follows the player.


# Initialization
func _ready() -> void:
	# Register
	Game.camera = self
	
	# Zoom is 3
	zoom = Vector2(3.0, 3.0)
	
	# Make sure the player is ready before setting them as starting position.
	_ready_deferred.call_deferred()
func _ready_deferred():
	position = Game.player.position


# Process
func _process(delta: float) -> void:
	# Get closer to player
	position = lerp(Game.player.position, position, exp(- delta * CAMERA_SPEED))

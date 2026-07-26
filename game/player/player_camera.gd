class_name PlayerCamera extends Camera2D

# Constants
var CAMERA_SPEED_X = 8.0
var CAMERA_SPEED_Y = 4.0

# Initialization
func _ready() -> void:
	# Register
	Game.camera = self
	
	# Zoom is 3
	zoom = Vector2(3.0, 3.0)
	
	# Make sure the player is ready before setting them as starting position.
	_ready_deferred.call_deferred()
	
func _ready_deferred():
	var player_position : Vector2 = Game.player.position
	var viewport_size := get_viewport_rect().size
	var half_camera_size := viewport_size / (2.0 * zoom)
	
	
	position = apply_camera_borders(player_position, player_position, half_camera_size)

# Process
func _process(delta: float) -> void:
	var player_position : Vector2 = Game.player.position
	var target_position : Vector2 = player_position

	var viewport_size: Vector2 = get_viewport_rect().size
	var half_camera_size: Vector2 = viewport_size / (2.0 * zoom)
	
	# Apply Camera borders
	target_position = apply_camera_borders(target_position, player_position, half_camera_size)

	position.x = lerp(target_position.x, position.x, exp(-delta * CAMERA_SPEED_X))
	position.y = lerp(target_position.y, position.y, exp(-delta * CAMERA_SPEED_Y))


func apply_camera_borders(target_position: Vector2, player_position: Vector2, half_camera_size: Vector2) -> Vector2:
	for border in get_tree().get_nodes_in_group("camera_borders"):
		target_position = border.clamp_camera(
			target_position,
			player_position,
			half_camera_size
		)

	return target_position

func reset():
	offset = Vector2.ZERO

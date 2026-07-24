# This sub-script is for Player logic that involves:
# • Processing player input to steer the character
# • Doing motion calculations
class_name PlayerMotion extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var jump_initial_velocity: float:
	get: return - 2.0 * player.jump_height / player.jump_time
var jump_gravity: float:
	get: return 2.0 * player.jump_height / pow(player.jump_time, 2)

var double_jump_initial_velocity: float:
	get: return - 2.0 * player.double_jump_height / player.double_jump_time
var double_jump_gravity: float:
	get: return 2.0 * player.double_jump_height / pow(player.double_jump_time, 2)

var cached_velocity: Vector2

var last_horizontal_direction: Enums.Direction = Enums.Direction.NONE
var last_wall_direction: Enums.Direction = Enums.Direction.NONE
var wall_jump_steering_cooldown: float = 0


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(delta: float) -> void:
	wall_jump_steering_cooldown = maxf(0, wall_jump_steering_cooldown - delta)
	
	# # Stop horizontal movement and prepare for a wall jump if hanging on a wall
	# elif player.current_state in [Player.State.HANGING]:
	if player.current_state in [Player.State.HANGING]:
		last_wall_direction = Enums.Direction.RIGHT if (player.get_wall_normal().angle() - PI / 2) > 0 else Enums.Direction.LEFT
		player.velocity.x = 0
	
	# Wall jump off direction is fixed (away from the wall) for a short time
	elif wall_jump_steering_cooldown:
		player.velocity.x = player.run_speed * (1 if last_wall_direction == Enums.Direction.LEFT else -1)

	# Bats invert horizontal direction on colliding with a wall, no steering on bounce frames
	elif player.is_on_wall() and player.current_state in [Player.State.JUMPING_BAT, Player.State.GLIDING_BAT, Player.State.FALLING_BAT]:
		player.velocity.x = - cached_velocity.x

	# Active horizontal steering by player input
	else:
		var move_left: int = 1 if Input.is_action_pressed(&'left') else 0
		var move_right: int = 1 if Input.is_action_pressed(&'right') else 0

		if player.is_on_floor():
			player.velocity.x = player.run_speed * (move_right - move_left)
		
		else:
			var air_speed_change_rate: float = (
				player.glide_air_speed_change_rate if player.current_state == Player.State.GLIDING else
				player.bat_glide_air_speed_change_rate if player.current_state == Player.State.GLIDING_BAT else
				player.air_speed_change_rate
			)
			player.velocity.x = lerp(player.velocity.x, player.run_speed * (move_right - move_left), exp(-delta / air_speed_change_rate))
	
	last_horizontal_direction = (
		Enums.Direction.LEFT if player.velocity.x < 0 else
		Enums.Direction.RIGHT if player.velocity.x > 0 else
		Enums.Direction.NONE
	)
	
	match player.current_state:
		Player.State.HANGING:
			player.velocity.y = 0
		
		Player.State.GLIDING:
			player.velocity.y = lerp(player.velocity.y, player.glide_max_fall_speed, exp(-delta / player.glide_fall_speed_decay_rate))
		
		Player.State.GLIDING_BAT:
			player.velocity.y = lerp(player.velocity.y, player.bat_glide_max_fall_speed, exp(-delta / player.bat_glide_fall_speed_decay_rate))
		
		Player.State.JUMPING_BAT:
			player.velocity.y += delta * double_jump_gravity
		
		_:
			player.velocity.y += delta * jump_gravity
	
	cached_velocity = player.velocity


func _on_player_reset() -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.JUMPING:
			player.velocity.y = minf(0, player.velocity.y) + jump_initial_velocity
		
		Player.State.JUMPING_BAT:
			player.velocity.y = minf(0, player.velocity.y) + double_jump_initial_velocity
	
	if player.previous_state == Player.State.HANGING:
		wall_jump_steering_cooldown = player.wall_jump_cooldown


func _on_player_hurt() -> void:
	pass

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

const IMMOBILE_STATES: Array[Player.State] = [
	# Player.State.CROUCHING,
	Player.State.TURNING_TO_MIST,
	Player.State.TURNING_TO_MIST_BAT,
	Player.State.TURNING_TO_ASHES,
	Player.State.TURNING_TO_ASHES_BAT,
	Player.State.ENTERING_COFFIN,
]

var bounce_velocity: Vector2

var last_horizontal_direction: Enums.Direction = Enums.Direction.NONE
var last_wall_direction: Enums.Direction = Enums.Direction.NONE
var wall_jump_cooldown_remaining: float = 0


func _on_player_physics_process(delta: float) -> void:
	wall_jump_cooldown_remaining = maxf(0, wall_jump_cooldown_remaining - delta)
	
	# Don't allow horizontal movement if the player is in an inactive state
	if player.current_state in IMMOBILE_STATES:
		player.velocity.x = 0
	
	# Stop horizontal movement and prepare for a wall jump if hanging on a wall
	elif player.current_state in [Player.State.HANGING]:
		last_wall_direction = Enums.Direction.RIGHT if (player.get_wall_normal().angle() - PI / 2) > 0 else Enums.Direction.LEFT
		player.velocity.x = 0
	
	# Wall jump off direction is fixed (away from the wall) for a short time
	elif wall_jump_cooldown_remaining:
		player.velocity.x = player.run_speed * (1 if last_wall_direction == Enums.Direction.LEFT else -1)

	# Invert horizontal direction on completing a wall bounce, no steering on bounce frames
	elif player.current_state in [Player.State.BOUNCE_END]:
		player.velocity.x = -bounce_velocity.x

	# Active horizontal steering by player input
	else:
		var move_left: int = 1 if Input.is_action_pressed(&'left') else 0
		var move_right: int = 1 if Input.is_action_pressed(&'right') else 0
		
		var h_speed: float = player.run_speed
		var h_speed_change_rate: float = player.run_speed_change_rate if player.is_on_floor() else player.air_speed_change_rate

		match player.current_state:
			Player.State.CROUCHING_RUN:
				h_speed = player.crouch_run_speed
				h_speed_change_rate = player.crouch_run_speed_change_rate

			Player.State.GLIDING_BAT:
				h_speed_change_rate = player.bat_glide_air_speed_change_rate

			Player.State.GLIDING:
				h_speed_change_rate = player.glide_air_speed_change_rate

			Player.State.JUMPING_BAT,\
			Player.State.FALLING_BAT:
				h_speed_change_rate = player.bat_air_speed_change_rate
		
		player.velocity.x = lerp(player.velocity.x, h_speed * (move_right - move_left), exp(-delta / h_speed_change_rate))
	
	# Cache player velocity on starting a bounce
	if player.current_state == Player.State.BOUNCE_START:
		if not bounce_velocity:
			bounce_velocity = player.velocity
		
		player.velocity.x = 0
	
	else:
		bounce_velocity = Vector2.ZERO
	
	last_horizontal_direction = (
		Enums.Direction.LEFT if player.velocity.x < 0 else
		Enums.Direction.RIGHT if player.velocity.x > 0 else
		Enums.Direction.NONE
	)

	if Input.is_action_just_released(&'jump') and player.velocity.y < 0:
		player.velocity.y *= player.short_jump_velocity_attenuation
	
	match player.current_state:
		Player.State.HANGING,\
		Player.State.BOUNCE_START:
			player.velocity.y = 0
		
		Player.State.GLIDING:
			player.velocity.y = lerp(player.velocity.y, player.glide_max_fall_speed, exp(-delta / player.glide_fall_speed_decay_rate))
		
		Player.State.GLIDING_BAT:
			player.velocity.y = lerp(player.velocity.y, player.bat_glide_max_fall_speed, exp(-delta / player.bat_glide_fall_speed_decay_rate))
		
		Player.State.JUMPING_BAT:
			player.velocity.y += delta * double_jump_gravity
		
		_:
			player.velocity.y += delta * jump_gravity
	
	player.velocity.y = minf(player.max_fall_speed, player.velocity.y)

	if player.velocity.x > 10:
		player.face(Enums.Direction.RIGHT)
	
	elif player.velocity.x < -10:
		player.face(Enums.Direction.LEFT)


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.JUMPING:
			player.velocity.y = jump_initial_velocity
		
		Player.State.JUMPING_BAT:
			if player.previous_state != Player.State.BOUNCE_END:
				player.velocity.y = double_jump_initial_velocity
	
	if player.previous_state == Player.State.HANGING:
		wall_jump_cooldown_remaining = player.wall_jump_cooldown

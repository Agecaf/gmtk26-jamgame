# This sub-script is for Player logic that involves:
# • Defining states and state transitions
# • Processing player input to trigger state transitions
# • Controlling animation states
class_name PlayerState extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var jump_keypress_interval: float = 0
var jump_hold_time: float = 0
var total_air_time: float = 0
var wall_jump_cooldown_remaining: float = 0
var bounce_cooldown_remaining: float = 0
var landing_delay_remaining: float = 0
var bounce_delay_remaining: float = 0


func _on_player_ready() -> void:
	# Put the wall detector raycast half the character's height above/below it
	player.wall_detector_top.position = player.terrain_collider.shape.get_rect().size.y * 0.5 * Vector2.UP
	player.wall_detector_bottom.position = player.terrain_collider.shape.get_rect().size.y * 0.5 * Vector2.DOWN
	# Then set it up to check a full width ahead of the character
	player.wall_detector_top.target_position = player.terrain_collider.shape.get_rect().size.x * Vector2.RIGHT
	player.wall_detector_bottom.target_position = player.terrain_collider.shape.get_rect().size.x * Vector2.RIGHT

	# Start in the falling state if the level spawns the character off the ground
	if not player.is_on_floor():
		player.change_state(Player.State.FALLING)


# # The evolution of player.current_state for debugging
# var x=0
# func _on_player_process(_delta: float) -> void:
# 	x += 1
# 	if x % 3 == 0:
# 		Debug.warning('%s' % [Player.State.find_key(player.current_state)])
# 	pass


func _on_player_physics_process(delta: float) -> void:
	jump_keypress_interval += delta
	jump_hold_time = (jump_hold_time + delta) if Input.is_action_pressed(&'jump') else 0.0
	
	var double_jump_keypress_timing: bool = (
		jump_keypress_interval >= player.double_jump_keypress_interval_min
		# and jump_keypress_interval <= player.double_jump_keypress_interval_max
	)

	total_air_time = 0.0 if player.is_on_floor() else (total_air_time + delta)

	wall_jump_cooldown_remaining = maxf(0, wall_jump_cooldown_remaining - delta)
	player.wall_detector_top.force_raycast_update()
	player.wall_detector_bottom.force_raycast_update()

	var wall_jump_conditions_met: bool = (
		total_air_time >= player.wall_jump_min_buildup_time
		and not wall_jump_cooldown_remaining
		and player.wall_detector_top.is_colliding()
		and player.wall_detector_bottom.is_colliding()
	)
	
	bounce_cooldown_remaining = maxf(0, bounce_cooldown_remaining - delta)
	
	var can_bounce: bool = (
		# absf(player.velocity.x) > player.bat_bounce_min_speed_required
		# and not bounce_cooldown_remaining
		not bounce_cooldown_remaining
	)

	landing_delay_remaining = maxf(0, landing_delay_remaining - delta)
	bounce_delay_remaining = maxf(0, bounce_delay_remaining - delta)
	
	match player.current_state:
		Player.State.IDLE:
			if Input.is_action_just_pressed(&'jump') and total_air_time <= player.coyote_time:
				player.change_state(Player.State.JUMPING)
				player.pocketwatch_close()
			
			elif Input.is_action_pressed(&'crouch'):
				player.change_state(Player.State.CROUCHING)
				player.pocketwatch_close()
			
			elif player.velocity.x:
				player.change_state(Player.State.RUNNING)
				player.pocketwatch_close()
		
		Player.State.RUNNING:
			if Input.is_action_just_pressed(&'jump') and total_air_time <= player.coyote_time:
				player.change_state(Player.State.JUMPING)
			
			## Crouch running is disabled
			# if Input.is_action_just_pressed(&'crouch'):
			# 	player.change_state(Player.State.CROUCHING_RUN)
			
			# Transition to crouching instead
			elif Input.is_action_just_pressed(&'crouch'):
				player.change_state(Player.State.CROUCHING)
			
			elif total_air_time >= player.falling_delay:
				player.change_state(Player.State.FALLING)
			
			elif not player.velocity.x:
				player.change_state(Player.State.IDLE)
		
		Player.State.CROUCHING:
			if Input.is_action_just_released(&'crouch'):
				player.change_state(Player.State.IDLE)
			
			## Crouch running is disabled
			# if player.velocity.x:
			# 	player.change_state(Player.State.CROUCHING_RUN)
		
		Player.State.CROUCHING_RUN:
			if Input.is_action_just_released(&'crouch'):
				player.change_state(Player.State.RUNNING)
			
			if not player.velocity.x:
				player.change_state(Player.State.CROUCHING)
		
		Player.State.HANGING:
			var back_action: StringName = &'left' if (player.get_wall_normal().angle() - PI / 2) > 0 else &'right'

			if Input.is_action_just_pressed(&'jump') or Input.is_action_just_pressed(back_action):
				player.change_state(Player.State.JUMPING)

			elif Input.is_action_just_pressed(&'crouch'):
				player.change_state(Player.State.JUMPING_FALL)
		
		Player.State.JUMPING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif player.is_on_wall_only() and wall_jump_conditions_met:
				player.change_state(Player.State.HANGING)
			
			elif Input.is_action_just_pressed(&'jump') and double_jump_keypress_timing:
				player.change_state(Player.State.JUMPING_BAT)
			
			elif jump_hold_time >= player.glide_start_delay:
				player.change_state(Player.State.GLIDING)

			elif player.velocity.y > 0 and total_air_time >= player.glide_start_delay:
				player.change_state(Player.State.JUMPING_FALL)
		
		Player.State.JUMPING_FALL:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif player.is_on_wall_only() and wall_jump_conditions_met:
				player.change_state(Player.State.HANGING)
			
			elif Input.is_action_just_pressed(&'jump') and double_jump_keypress_timing:
				player.change_state(Player.State.JUMPING_BAT)
			
			elif jump_hold_time >= player.glide_start_delay:
				player.change_state(Player.State.GLIDING)
		
		Player.State.JUMPING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif jump_hold_time >= player.bat_glide_start_delay:
				player.change_state(Player.State.GLIDING_BAT)
			
			elif player.is_on_wall() and can_bounce:
				player.change_state(Player.State.BOUNCE_START)

		Player.State.GLIDING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif player.is_on_wall_only() and wall_jump_conditions_met:
				player.change_state(Player.State.HANGING)
			
			elif Input.is_action_just_pressed(&'jump') and double_jump_keypress_timing:
				player.change_state(Player.State.JUMPING_BAT)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING)

		Player.State.GLIDING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING_BAT)
			
			elif player.is_on_wall() and can_bounce:
				player.change_state(Player.State.BOUNCE_START)

		Player.State.BOUNCE_START:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING_BAT)
			
			elif not bounce_delay_remaining:
				player.change_state(Player.State.BOUNCE_END)

		Player.State.BOUNCE_END:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING_BAT)
			
			elif jump_hold_time >= player.bat_glide_start_delay:
				player.change_state(Player.State.GLIDING_BAT)

			else:
				player.change_state(Player.State.JUMPING_BAT)

		Player.State.FALLING:
			if player.is_on_floor():
				player.change_state(Player.State.LANDING)
			
			elif Input.is_action_just_pressed(&'jump') and double_jump_keypress_timing:
				player.change_state(Player.State.JUMPING_BAT)

		Player.State.FALLING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.LANDING_BAT)

		Player.State.LANDING,\
		Player.State.LANDING_BAT:
			if not landing_delay_remaining:
				player.change_state(Player.State.IDLE)
		
		Player.State.REFORMING:
			# TODO: Animation delay?
			player.change_state(Player.State.IDLE)
		
		Player.State.TURNING_TO_MIST,\
		Player.State.TURNING_TO_ASHES,\
		Player.State.ENTERING_COFFIN:
			pass

	if Input.is_action_just_pressed(&'jump'):
		jump_keypress_interval = 0


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.IDLE,\
		Player.State.RUNNING,\
		Player.State.CROUCHING,\
		Player.State.CROUCHING_RUN,\
		Player.State.JUMPING,\
		Player.State.JUMPING_FALL,\
		Player.State.GLIDING,\
		Player.State.FALLING,\
		Player.State.TURNING_TO_MIST,\
		Player.State.REFORMING,\
		Player.State.TURNING_TO_ASHES,\
		Player.State.ENTERING_COFFIN:
			player.change_form(Player.Form.VAMPIRE)
		
		Player.State.HANGING:
			player.change_form(Player.Form.VAMPIRE)
			wall_jump_cooldown_remaining = player.wall_jump_cooldown

		Player.State.LANDING:
			player.change_form(Player.Form.VAMPIRE)
			landing_delay_remaining = player.landing_delay
		
		Player.State.JUMPING_BAT,\
		Player.State.GLIDING_BAT,\
		Player.State.BOUNCE_END,\
		Player.State.FALLING_BAT:
			player.change_form(Player.Form.BAT)
		
		Player.State.BOUNCE_START:
			player.change_form(Player.Form.BAT)
			bounce_delay_remaining = player.bat_bounce_delay

		Player.State.LANDING_BAT:
			player.change_form(Player.Form.BAT)
			landing_delay_remaining = player.bat_landing_delay

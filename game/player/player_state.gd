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


func _on_player_ready() -> void:
	# Put the wall detector raycast a full height above the character
	player.wall_detector.position = player.collider.shape.get_rect().size.y * Vector2.UP
	# Then set it up to check a full width ahead of the character
	player.wall_detector.target_position = player.collider.shape.get_rect().size.x * Vector2.RIGHT

	# Start in the falling state if the level spawns the character off the ground
	if not player.is_on_floor():
		player.change_state(Player.State.FALLING)


func _on_player_process(_delta: float) -> void:
	pass


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
		and jump_keypress_interval <= player.double_jump_keypress_interval_max
	)

	total_air_time = 0.0 if player.is_on_floor() else (total_air_time + delta)
	wall_jump_cooldown_remaining = maxf(0, wall_jump_cooldown_remaining - delta)

	player.wall_detector.force_raycast_update()

	var wall_jump_conditions_met: bool = (
		total_air_time >= player.wall_jump_min_buildup_time
		and not wall_jump_cooldown_remaining
		and player.wall_detector.is_colliding()
	)
	
	match player.current_state:
		Player.State.IDLE:
			if Input.is_action_just_pressed(&'jump') and total_air_time <= player.coyote_time:
				player.change_state(Player.State.JUMPING)
		
		Player.State.HANGING:
			var back_action: StringName = &'left' if (player.get_wall_normal().angle() - PI / 2) > 0 else &'right'

			if Input.is_action_just_pressed(&'jump'):
				player.change_state(Player.State.JUMPING)

			elif Input.is_action_just_pressed(&'crouch') or Input.is_action_just_pressed(back_action):
				player.change_state(Player.State.FALLING)
		
		Player.State.JUMPING:
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

		Player.State.GLIDING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif player.is_on_wall_only() and wall_jump_conditions_met:
				player.change_state(Player.State.HANGING)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING)

		Player.State.GLIDING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
				
			elif Input.is_action_just_released(&'jump'):
				player.change_state(Player.State.FALLING_BAT)

		Player.State.FALLING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)

		Player.State.FALLING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)

	if Input.is_action_just_pressed(&'jump'):
		jump_keypress_interval = 0


func _on_player_reset() -> void:
	pass


func _on_player_face(_direction: Enums.Direction) -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.IDLE:
			player.change_form(Player.Form.VAMPIRE)
		
		Player.State.HANGING:
			player.change_form(Player.Form.VAMPIRE)
			wall_jump_cooldown_remaining = player.wall_jump_cooldown
		
		Player.State.JUMPING:
			player.change_form(Player.Form.VAMPIRE)
		
		Player.State.JUMPING_BAT:
			player.change_form(Player.Form.BAT)

		Player.State.GLIDING:
			player.change_form(Player.Form.VAMPIRE)

		Player.State.GLIDING_BAT:
			player.change_form(Player.Form.BAT)

		Player.State.FALLING:
			player.change_form(Player.Form.VAMPIRE)

		Player.State.FALLING_BAT:
			player.change_form(Player.Form.BAT)


func _on_player_change_form(_form: Player.Form) -> void:
	pass


func _on_player_hurt() -> void:
	pass

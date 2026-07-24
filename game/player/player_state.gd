# This sub-script is for Player logic that involves:
# • Defining states and state transitions
# • Processing player input to trigger state transitions
# • Controlling animation states
class_name PlayerState extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var jump_keypress_interval: float = 0
var jump_hold_time: float = 0


func _on_player_ready() -> void:
	if not player.is_on_floor():
		player.change_state(Player.State.FALLING)


func _on_player_process(_delta: float) -> void:
	pass


## The evolution of player.current_state for debugging
# var x=0
# func _on_player_process(_delta: float) -> void:
# 	x += 1
# 	if x % 3 == 0:
# 		Debug.warning('%s' % [Player.State.find_key(player.current_state)])
# 	pass


func _on_player_physics_process(delta: float) -> void:
	jump_hold_time = (jump_hold_time + delta) if Input.is_action_pressed('ui_up') else 0.0
	jump_keypress_interval += delta
	
	var double_jump_keypress_timing: bool = (
		jump_keypress_interval >= player.double_jump_keypress_interval_min
		and jump_keypress_interval <= player.double_jump_keypress_interval_max
	)

	match player.current_state:
		Player.State.IDLE:
			if Input.is_action_just_pressed('ui_up') and player.is_on_floor():
				player.change_state(Player.State.JUMPING)
		
		Player.State.JUMPING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
			
			elif Input.is_action_just_pressed('ui_up') and double_jump_keypress_timing:
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
				
			elif Input.is_action_just_released('ui_up'):
				player.change_state(Player.State.FALLING)

		Player.State.GLIDING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)
				
			elif Input.is_action_just_released('ui_up'):
				player.change_state(Player.State.FALLING_BAT)

		Player.State.FALLING:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)

		Player.State.FALLING_BAT:
			if player.is_on_floor():
				player.change_state(Player.State.IDLE)

	if Input.is_action_just_pressed('ui_up'):
		jump_keypress_interval = 0


func _on_player_reset() -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	pass


func _on_player_hurt() -> void:
	pass

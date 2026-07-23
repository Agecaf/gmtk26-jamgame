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


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(delta: float) -> void:
	var move_left: int = 1 if Input.is_action_pressed('ui_left') else 0
	var move_right: int = 1 if Input.is_action_pressed('ui_right') else 0
	
	player.velocity.x = player.speed * (move_right - move_left)

	if player.current_state == Player.State.JUMPING_BAT:
		player.velocity.y += delta * double_jump_gravity
	else:
		player.velocity.y += delta * jump_gravity


func _on_player_reset() -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.JUMPING:
			player.velocity.y = minf(0, player.velocity.y) + jump_initial_velocity
		Player.State.JUMPING_BAT:
			player.velocity.y = minf(0, player.velocity.y) + double_jump_initial_velocity

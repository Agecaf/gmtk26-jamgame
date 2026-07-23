# This sub-script is for Player logic that involves:
# • Defining states and state transitions
# • Processing player input to trigger state transitions
# • Controlling animation states
class_name PlayerState extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var current_state: Player.State


func _on_player_ready() -> void:
	current_state = Player.State.IDLE


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
	if current_state == Player.State.IDLE:
		if Input.is_action_just_pressed('ui_up') and player.is_on_floor():
			player.change_state(Player.State.JUMPING)
	
	elif current_state == Player.State.JUMPING:
		if player.is_on_floor():
			player.change_state(Player.State.IDLE)
		
		if Input.is_action_just_pressed('ui_up'):
			player.change_state(Player.State.JUMPING_BAT)
	
	elif current_state == Player.State.JUMPING_BAT:
		if player.is_on_floor():
			player.change_state(Player.State.IDLE)


func _on_player_reset() -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	current_state = state

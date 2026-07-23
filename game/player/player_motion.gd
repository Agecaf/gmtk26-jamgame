# This sub-script is for Player logic that involves:
# • Processing player input to steer the character
# • Doing motion calculations
class_name PlayerMotion extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var can_jump: bool


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(delta: float) -> void:
	var jump_pressed: bool = Input.is_action_just_pressed('ui_up')
	
	can_jump = player.is_on_floor()
	
	if jump_pressed and can_jump:
		can_jump = false
		player.velocity.y = player.jump_initial_velocity
	
	var move_left: int = 1 if Input.is_action_pressed('ui_left') else 0
	var move_right: int = 1 if Input.is_action_pressed('ui_right') else 0
	
	player.velocity.x = player.speed * (move_right - move_left)
	player.velocity.y += delta * player.jump_gravity


func _on_player_reset() -> void:
	can_jump = true

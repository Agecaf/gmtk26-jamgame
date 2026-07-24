# This sub-script is for Player logic that involves:
# • Managing the animation player
class_name PlayerAnim extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var animator: AnimationPlayer:
	get: return player.get_node(^'Animator')


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
	pass


func _on_player_reset() -> void:
	pass


func _on_player_face(_direction: Enums.Direction) -> void:
	pass


func _on_player_change_state(state: Player.State) -> void:
	animator.stop()
	
	match state:
		Player.State.IDLE:
			animator.play(&'Vampire/Idle')


func _on_player_change_form(_form: Player.Form) -> void:
	pass


func _on_player_hurt() -> void:
	pass

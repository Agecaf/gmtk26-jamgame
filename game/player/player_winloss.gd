# This sub-script is for Player logic that involves:
# • Triggers when the countdown reaches zero
# • Triggers on completing levels and/or the game
class_name PlayerWinLoss extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
	pass


func _on_player_reset() -> void:
	pass

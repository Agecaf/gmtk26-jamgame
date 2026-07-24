extends Node2D

func _ready() -> void:
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	Game.countdown.tick.connect(update_watch)

func update_watch(seconds_left: int) -> void:
	%TimeLabel.text = str(seconds_left)

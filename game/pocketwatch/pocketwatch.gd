class_name PocketWatch extends Node2D

func _ready() -> void:
	# Register
	Game.pocketwatch = self
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	Game.countdown.tick.connect(update_watch)

var target_position: Vector2 = Vector2(300, 1500)
var target_open: Vector2 = Vector2(300, 800)
var target_closed: Vector2 = Vector2(300, 1500)

func update_watch(seconds_left: int) -> void:
	%TimeLabel.text = str(seconds_left)

# Open and close pocketwatch
func _process(delta: float) -> void:
	%PocketwatchSmall.position = lerp(
		target_position, %PocketwatchSmall.position, 
		exp(-delta * 10.0)
	)

func open() -> void: target_position = target_open
func close() -> void: target_position = target_closed

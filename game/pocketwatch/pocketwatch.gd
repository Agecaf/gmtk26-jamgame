class_name PocketWatch extends Node2D

func _ready() -> void:
	# Register
	Game.pocketwatch = self
	_ready_deferred.call_deferred()
func _ready_deferred() -> void:
	Game.countdown.tick.connect(update_watch)
	Game.countdown.timeout.connect(update_watch.bind(0))

var target_position: Vector2 = Vector2(300, 1500)
var target_open: Vector2 = Vector2(300, 800)
var target_closed: Vector2 = Vector2(300, 1500)

func update_watch(seconds_left: int) -> void:
	%TimeLabel.text = str(seconds_left)

# Open and close pocketwatch
var countdown_started: bool = false
func _process(delta: float) -> void:
	
	# Position pocketwatch
	%PocketwatchSmall.position = lerp(
		target_position, %PocketwatchSmall.position, 
		exp(-delta * 10.0)
	)
	
	# Update checkpoint text
	if Game.player != null and is_instance_valid(Game.player):
		if Game.player.animator_vampire.current_animation.ends_with("Idle_2"):
			var t: float = Game.player.animator_vampire.current_animation_position
			
			# Font size
			if Game.menu != null:
				if Game.menu.theme.default_font_size == 43:
					%CheckpointLabel.label_settings.font_size = 43
				else:
					%CheckpointLabel.label_settings.font_size = 32
			
			# Text
			if t < 4.0:
				%CheckpointLabel.text = "Checkpoint in %d..." % ceili(4.0 - t)
			else:
				%CheckpointLabel.text = "Checkpoint ready!"
			
			# Countdown
			if t > 0.6 and not countdown_started:
				Game.audio.count_sfx.stop()
				Game.audio.count_sfx.play()
				countdown_started = true
		else:
			countdown_started = false

func open() -> void: 
	target_position = target_open
func close() -> void: 
	target_position = target_closed
	if countdown_started:
		Game.audio.count_sfx.stop()

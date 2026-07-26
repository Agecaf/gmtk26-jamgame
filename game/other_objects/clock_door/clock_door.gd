class_name ClockDoor extends Node2D

@onready var door: Sprite2D = %Door
@onready var dial: Sprite2D = %DoorDial
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var asp: AudioStreamPlayer2D = %ASP

@export var long_or_short: bool = false

var open_sfx = preload("res://assets/audio/sfx/clock_door_opens.wav")
var tick_sfx = preload("res://assets/audio/sfx/clock_tick.wav")

var max_time: float = 0.0
var t: float = 8.0
var started: bool = false
var opened: bool = false
var target_dial_rotation: float = 0.0

func _ready() -> void:
	if long_or_short: max_time = 8.0
	else: max_time = 4.0
	t = max_time

func _process(delta: float) -> void:
	
	# Advance time only if started
	if started or opened: t -= delta
	
	# Check for player proximity to start the timer
	if not started and not opened:
		if Game.player.position.distance_to(position) < 80.0:
			started = true
			asp.stream = tick_sfx
			asp.play()
	
	# Open door
	if t <= 0 and started: 
		started = false
		opened = true
		t = 0
		collision_shape.disabled = true
		# Sfx
		asp.stop()
		asp.stream = open_sfx
		asp.play()
	
	# Rotate door dial
	if started: 
		target_dial_rotation = -TAU * (floor(t) / max_time)
		dial.rotation = lerp_angle(target_dial_rotation, dial.rotation, exp(- delta * 20.0))
	
	# Opening animation
	if opened:
		door.frame = clampi(floor(-t * 5.0), 0, 3)
		dial.modulate = Color(1.0, 1.0, 1.0, 1.0 - clampi(floor(-t * 5.0), 0, 3) / 3.0)
		door.modulate = Color(1.0, 1.0, 1.0, 1.0 - clampi(floor(-t * 5.0 - 2.0), 0, 3) / 3.0)
	
	pass

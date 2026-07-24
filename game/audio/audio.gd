class_name AudioClass extends Node2D

@onready var menu_music: AudioStreamPlayer = %MenuMusic
@onready var game_music: AudioStreamPlayer = %GameMusic
@onready var clock_music: AudioStreamPlayer = %ClockTicks
@onready var sfx_asp: AudioStreamPlayer = %SFXASP

var sfx_asp_pool: Array[AudioStreamPlayer] = []
var sfx_asp_index: int = 0
var mute: bool = false

# Initialization
func _ready() -> void:
	# Register
	Game.audio = self
	
	# Fill ASP Pool
	for idx in 8:
		var asp: AudioStreamPlayer = sfx_asp.duplicate(DUPLICATE_DEFAULT)
		sfx_asp_pool.push_back(asp)
		add_child(asp)

func get_sfx_asp() -> AudioStreamPlayer:
	var asp: AudioStreamPlayer = sfx_asp_pool[sfx_asp_index]
	asp.stop()
	sfx_asp_index = posmod(sfx_asp_index+1, len(sfx_asp_pool))
	return asp

# Listen for mute input
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"mute"):
		mute = not mute
		AudioServer.set_bus_mute(0, mute)

class_name AudioClass extends Node2D

@onready var music_asp: AudioStreamPlayer = %MusicASP
@onready var sfx_asp: AudioStreamPlayer = %SFXASP

# Initialization
func _ready() -> void:
	# Register
	Game.audio = self

extends Control


@onready var return_button: Button = %Return
@onready var music_volume: HSlider = %MusicVolume
@onready var font_button: Button = %FontButton
@onready var sfx_volume: HSlider = %SFXVolume

# Initialization
func _ready() -> void:
	# Connect
	return_button.pressed.connect(return_to_previous)
	sfx_volume.value_changed.connect(sfx_changed)
	music_volume.value_changed.connect(music_changed)
	font_button.pressed.connect(change_font)
	sfx_volume.value = 80
	music_volume.value = 80
	sfx_changed(80)
	music_changed(80)

# Return to previous menu
func return_to_previous() -> void:
	Game.menu.go_to(Game.menu.previous_menu_name)

# Set the initial startup.
func start() -> void:
	if Game.menu.previous_menu_name == &"MainMenu":
		return_button.text = "Return to Main Menu"
	if Game.menu.previous_menu_name == &"PauseMenu":
		return_button.text = "Return to Pause Menu"

func music_changed(value: float) -> void:
	AudioServer.set_bus_mute(1, value <= 2.0)
	AudioServer.set_bus_volume_linear(1, value / 100.0)

func sfx_changed(value: float) -> void:
	AudioServer.set_bus_mute(2, value <= 2.0)
	AudioServer.set_bus_volume_linear(2, value / 200.0)


# Change font
var which_font: bool = true
var pixel_font = preload("res://assets/other/font/Jacquard24-Regular.ttf")
var other_font = preload("res://assets/other/font/Rosarivo-Regular.ttf")
func change_font() -> void:
	which_font = not which_font
	if which_font:
		Game.menu.theme.default_font = pixel_font
		Game.menu.theme.default_font_size = 43
	else:
		Game.menu.theme.default_font = other_font
		Game.menu.theme.default_font_size = 40
	pass

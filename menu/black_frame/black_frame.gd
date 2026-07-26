class_name BlackFrame extends Node2D

@onready var black_frame = %BlackFrame
@onready var victory_bg = %VictoryBg
@onready var victory_count = %VictoryCount
@onready var victory_z = %VictoryZ

var menus_with_black_frame: Array[StringName] = [
	&"PreLevelMenu", 
	&"PauseMenu",
	&"SettingsMenu",
	&"PostLevelMenu"
]
var target_alpha: float = 0.0
var fade_speed: float = 10.0

# Begin
func _ready() -> void:
	# Register
	Game.black_frame = self
	_ready_deferred.call_deferred()
	
func _ready_deferred():
	Game.menu.menu_changed.connect(check_menu)
	victory_bg.modulate = Color(0.0, 0.0, 0.0, 0.0)
	victory_count.modulate = Color(0.0, 0.0, 0.0, 0.0)
	victory_z.modulate = Color(0.0, 0.0, 0.0, 0.0)
	black_frame.modulate = Color(1.0, 1.0, 1.0, 0.0)

# Timer for delay
var delay = 0.0

# Check if we should be visible or not
func check_menu() -> void:
	# Check delay
	if Game.menu.current_menu != null:
		if Game.menu.next_menu_name == &"PostLevelMenu": 
			if Game.victory: delay = 5.0
			else: delay = 1.0
		else: delay = 0.0
	
	# Check target position
	if Game.menu.current_menu != null:
		if Game.menu.current_menu.name in menus_with_black_frame:
			target_alpha = 1.0
		else:
			target_alpha = 0.0

# Fade in and out
func _process(delta: float) -> void:
	# Black frame
	if delay > 0: delay -= delta
	else:
		black_frame.modulate = lerp(Color(1.0, 1.0, 1.0, target_alpha), black_frame.modulate, exp(-delta * fade_speed))
		
	# Victory
	if Game.menu.current_menu.name == &"PostLevelMenu" and Game.victory:
		if delay <= 0:
			delay -= delta
			victory_bg.modulate = lerp(Color(0.0, 0.0, 0.0, 0.0), Color.WHITE, clampf( 0.0 - delay,0.0, 1.0))
			victory_count.modulate = lerp(Color(0.0, 0.0, 0.0, 0.0), Color.WHITE, clampf( -1.0 - delay,0.0, 1.0))
			victory_z.modulate = lerp(Color(0.0, 0.0, 0.0, 0.0), Color.WHITE, clampf( -2.0 - delay,0.0, 1.0))
	if Game.menu.current_menu.name != &"PostLevelMenu":
		victory_bg.modulate = lerp(Color(0.0, 0.0, 0.0, 0.0), victory_bg.modulate, exp(-delta * fade_speed))
		victory_count.modulate = victory_bg.modulate
		victory_z.modulate = victory_bg.modulate

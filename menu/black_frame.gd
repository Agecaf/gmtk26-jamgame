class_name BlackFrame extends Sprite2D

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
	_ready_deferred.call_deferred()
	
func _ready_deferred():
	Game.menu.menu_changed.connect(check_menu)

# Timer for delay
var delay = 0.0

# Check if we should be visible or not
func check_menu() -> void:
	# Check delay
	if Game.menu.next_menu_name == &"PostLevelMenu": delay = 2.0
	else: delay = 0.0
	
	# Check target position
	if Game.menu.current_menu != null:
		if Game.menu.current_menu.name in menus_with_black_frame:
			target_alpha = 1.0
		else:
			target_alpha = 0.0

# Fade in and out
func _process(delta: float) -> void:
	if delay > 0: delay -= delta
	else:
		modulate = lerp(Color(1.0, 1.0, 1.0, target_alpha), modulate, exp(-delta * fade_speed))

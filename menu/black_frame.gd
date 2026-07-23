class_name BlackFrame extends Sprite2D

var menus_with_black_frame: Array[StringName] = [&"PreLevelMenu", &"PauseMenu"]
var target_alpha: float = 0.0
var fade_speed: float = 10.0

# Begin
func _ready() -> void:
	_ready_deferred.call_deferred()
	
func _ready_deferred():
	Game.menu.menu_changed.connect(check_menu)

# Check if we should be visible or not
func check_menu() -> void:
	print("Menu changed; ", Game.menu.current_menu)
	if Game.menu.current_menu != null:
		if Game.menu.current_menu.name in menus_with_black_frame:
			print("fading in")
			target_alpha = 1.0
		else:
			print("fading out")
			target_alpha = 0.0

# Fade in and out
func _process(delta: float) -> void:
	modulate = lerp(Color(1.0, 1.0, 1.0, target_alpha), modulate, exp(-delta * fade_speed))

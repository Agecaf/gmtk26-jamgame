class_name GameText extends Label

var base_text: String
var pixel_font = preload("res://assets/other/font/Jacquard12-Regular.ttf")
var other_font = preload("res://assets/other/font/Rosarivo-Regular.ttf")

func _ready() -> void:
	_ready_deferred.call_deferred()
	base_text = text
func _ready_deferred():
	Game.countdown.tick.connect(update)

func update(sec_left):
	# Choose font
	if Game.menu != null:
		if Game.menu.theme.default_font_size == 43:
			label_settings.font = pixel_font
			label_settings.font_size = 21
		else:
			label_settings.font = other_font
			label_settings.font_size = 18
	text = base_text.format({
		"left": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"left")[0].physical_keycode).to_lower(), 
		"right": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"right")[0].physical_keycode).to_lower(), 
		"jump": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"jump")[0].physical_keycode).to_lower(), 
		"crouch": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"crouch")[0].physical_keycode).to_lower(), 
		"pause": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"pause")[0].physical_keycode).to_lower(), 
		"mute": "[%s]" % KeyUtils.keycode_to_char(InputMap.action_get_events(&"mute")[0].physical_keycode).to_lower(), 
		"time": str(sec_left),
	})

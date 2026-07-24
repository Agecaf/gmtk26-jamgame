extends Node


func _init() -> void:
	# Set up alternate keybindings alongside the default ones
	var extra_keybindings: Dictionary[Key, StringName] = {
		KEY_UP:     &'jump',    # W = ↑
		KEY_LEFT:   &'left',    # A = ←
		KEY_DOWN:   &'crouch',  # S = ↓
		KEY_RIGHT:  &'right',   # D = →
	}

	for key: Key in extra_keybindings:
		var action: StringName = extra_keybindings[key]

		var event: InputEventKey = InputEventKey.new()
		event.physical_keycode = key
		
		InputMap.action_add_event(action, event)

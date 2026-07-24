extends Button

@export var control_name: StringName = &""

var changing: bool = false

func _ready() -> void:
	update()
	custom_minimum_size = Vector2(200, 80)


func _pressed() -> void:
	if not changing:
		changing = true
		update()

func update():
	if changing:
		text = "[press key]"
	else:
		var event = InputMap.action_get_events(control_name)[0]
		if event is InputEventKey:
			text = "[%s]" % KeyUtils.keycode_to_char(event.physical_keycode).to_lower()

func _input(event: InputEvent) -> void:
	print(event)
	if not changing: return
	if not event is InputEventKey: return
	if not event.pressed: return
	InputMap.action_erase_events(control_name)
	InputMap.action_add_event(control_name, event)
	changing = false
	update()

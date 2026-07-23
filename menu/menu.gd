class_name Menu extends Control


# Initialization
func _ready() -> void:
	# Register
	Game.menu = self
	
	# Hide children
	for child in get_children():
		child.hide()
		(child as Control).mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	
	# First menu is main menu
	go_to(&"MainMenu")

# To to another menu.
func go_to(menu_name: StringName) -> void:
	for child in get_children():
		if child.name == menu_name:
			child.show()
			(child as Control).mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
		else:
			child.hide()
			(child as Control).mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED

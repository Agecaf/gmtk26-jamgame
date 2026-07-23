class_name Menu extends Control

signal menu_changed()
var current_menu: Control
var previous_menu_name: StringName = &""
var next_menu_name: StringName = &""

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
	# End the previous menu
	next_menu_name = menu_name
	if current_menu != null:
		if current_menu.has_method(&"end"): current_menu.call(&"end")
		previous_menu_name = current_menu.name
	
	# Find the menu
	for child in get_children():
		if child.name == menu_name:
			child.show()
			(child as Control).mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_ENABLED
			current_menu = child
			if current_menu.has_method(&"start"): current_menu.call(&"start")
		else:
			child.hide()
			(child as Control).mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	
	menu_changed.emit()

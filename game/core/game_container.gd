class_name GameContainer extends Node2D

@export var levels: Array[PackedScene] = []
@export_multiline var start_text: Array[String] = []

# Initialization
func _ready() -> void:
	# Register
	Game.container = self
	

func unload() -> void:
	# Kill all children
	for child in get_children():
		remove_child(child)
		child.queue_free()

# Loads a level
func load_level() -> void:
	var level_index: int = Game.level_index
	# Make sure we have levels
	if level_index < 0 or level_index >= len(levels):
		Debug.error("Not enough levels: %d" % level_index )
		return
	
	unload()
	
	# Add level scene
	var new_level = levels[level_index].instantiate()
	add_child(new_level)

extends Node2D

@export var number_of_small_clouds = 20
@onready var sky: Sprite2D = %Sky
var small_cloud_frames = preload("res://assets/art/background/small_clouds.tres")

var time: int = 0

var bg_colors: Array[Color] = [
	Color("#000000"),
	Color("#452729"),
	Color("#702c1f"),
	Color("#702c1f"),
	Color("#4f5878"),
]

func _ready() -> void:
	# Add small clouds
	for idx in number_of_small_clouds:
		var small_cloud = AnimatedSprite2D.new()
		small_cloud.sprite_frames = small_cloud_frames
		var type = randi_range(0, 5)
		small_cloud.set_meta(&"type", type)
		small_cloud.frame = type * 5
		
		small_cloud.scale = Vector2(3.0, 3.0)
		small_cloud.position = Vector2(randi_range(0, 640) * 3.0, randi_range(20, 180) * 3.0)
		%SmallClouds.add_child(small_cloud)
	
	# Update for the first time
	update()

func _process(delta: float) -> void:
	# Check time and update
	if Input.is_action_just_pressed("ui_accept"):
		time = posmod(time+1, 5)
		update()
	
	# Move small clouds
	for sc in %SmallClouds.get_children():
		sc.position.x += (100.0 + sc.position.y) * delta * 0.02
		if sc.position.x > 2000: sc.position.x = -200
	

func update() -> void:
	sky.modulate = bg_colors[time]
	
	# Animate big clouds
	for child in get_children():
		if child is AnimatedSprite2D:
			child.frame = time
	
	# Animate small clouds
	for sc in %SmallClouds.get_children():
		sc.frame = sc.get_meta(&"type") * 5 + time

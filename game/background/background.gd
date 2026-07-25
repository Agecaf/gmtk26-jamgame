extends Node2D

@export var number_of_small_clouds = 20
@onready var sky: Sprite2D = %Sky
@onready var sun: AnimatedSprite2D = %Sun
@onready var horizon: Sprite2D = %Horizon
var small_cloud_frames = preload("res://assets/art/background/small_clouds.tres")

var time: int = 0

var bg_colors: Array[Color] = [
	Color("#000000"),
	Color("#000000"),
	Color("#000000"),
	Color("#452729"),
	Color("#452729"),
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
	
	# Listen to countdown
	Game.countdown.tick.connect(on_tick)
	
	# Update for the first time
	update()

func _process(delta: float) -> void:
	# Move small clouds
	for sc in %SmallClouds.get_children():
		sc.position.x += (100.0 + sc.position.y) * delta * 0.02
		if sc.position.x > 2000: sc.position.x = -200
	
	# Horizon
	if Game.countdown.is_stopped():
		horizon.modulate = Color.DARK_RED
	else:
		var l = 1.0 - Game.countdown.time_left / 60.0
		horizon.modulate = Color(l, l, l, 1.0)
	
	
	# Sun
	if Game.countdown.is_stopped():
		sun.position.y = 450
	else:
		sun.position.y = lerpf(450, 700, Game.countdown.time_left / 60.0)


func on_tick(seconds_left: int) -> void:
	if seconds_left < 10: time = 4
	elif seconds_left < 20: time = 3
	elif seconds_left < 30: time = 2
	elif seconds_left < 45: time = 1
	else: time = 0
	update()


func update() -> void:
	sky.modulate = bg_colors[time]
	
	# Animate big clouds
	for child in get_children():
		if child is AnimatedSprite2D:
			child.frame = time
	
	# Animate small clouds
	for sc in %SmallClouds.get_children():
		sc.frame = sc.get_meta(&"type") * 5 + time

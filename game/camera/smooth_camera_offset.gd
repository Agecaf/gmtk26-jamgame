class_name Camera extends Area2D

## Offset of the camera horizontally
@export var offset_x : float
## Offset of the camera vertically
@export var offset_y : float

## Ignores the vertical camera offset
@export var x_only : bool
## Ignores the horizontal camera offset
@export var y_only : bool

## How long it takes to reach the desired offset
@export var time : float = 0.5
## The offset will be instant, overrides time
@export var instant : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instant:
		time = 0.0
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		
		if x_only and not y_only:
			tween.tween_property(Game.camera, "offset:x", offset_x, time)
		elif y_only and not x_only:
			tween.tween_property(Game.camera, "offset:y", offset_y, time)
		else:
			tween.tween_property(Game.camera, "offset", Vector2(offset_x, offset_y), time)

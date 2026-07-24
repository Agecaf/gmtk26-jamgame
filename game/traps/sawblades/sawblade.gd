class_name Sawblade extends Path2D

@export var move_duration : float = 1
@export var wait_time : float = 0.25
@export var transition_type : Tween.TransitionType =  Tween.TRANS_CUBIC
@export var is_moving : bool = false

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var pause_timer: Timer = $PauseTimer


var direction : int = 1
var is_waiting : bool = false

func _ready() -> void:
	pause_timer.wait_time = wait_time
	
	move_loop()
	
func move_loop():
	while is_moving:
		
		await move_to(curve.get_baked_length()) # move to end
		if not is_moving: break
		
		pause_timer.start()
		await pause_timer.timeout
		if not is_moving: break
		
		await move_to(0.0) # move to beginning
		if not is_moving: break
		
		pause_timer.start()
		await pause_timer.timeout
		if not is_moving: break

func move_to(target: float):
	var tween = create_tween()
	tween.tween_property(path_follow_2d, "progress", target, move_duration)\
		 .set_trans(transition_type)\
		 .set_ease(Tween.EASE_IN_OUT)
	await tween.finished
		
func reset_sawblade():
	is_moving = false  
	
	pause_timer.stop()
	pause_timer.timeout.emit()
	
	path_follow_2d.progress = 0

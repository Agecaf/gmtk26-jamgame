class_name Countdown extends Timer


signal tick(sec_left)


var sec_left: int


func _ready() -> void:
	one_shot = true
	Game.countdown = self


func _process(_delta: float) -> void:
	if sec_left != ceili(time_left):
		sec_left = ceili(time_left)

		if sec_left:
			tick.emit(sec_left)


func set_timer(time_sec: float = -1) -> void:
	start(time_sec)

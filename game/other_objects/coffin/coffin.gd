extends Node2D

@onready var back_effect: Sprite2D = %BackEffect


var t = 0.0
var player_grabbed: bool = false
var grab_width: float = 50
var grab_height: float = 40

var left_grab_offset: Vector2 = Vector2(-20, -24)
var right_grab_offset: Vector2 = Vector2(50, -24)
var grab_direction: Enums.Direction


func _ready() -> void:
	Game.coffin_sequence_start.connect(func():
		get_tree().create_tween().tween_property($Coffin, ^'self_modulate', Color('#ffffff00'), 1.0)
	)


func _process(delta: float) -> void:
	
	# Update graphics
	t += delta
	var lambda = 0.5 * sin(t * PI) + 0.5
	var gradient: Gradient = (back_effect.texture as GradientTexture2D).gradient
	gradient.set_offset(1, lerpf(0.3, 0.35, lambda))
	gradient.set_offset(2, lerpf(0.4, 0.5, lambda))

	var left_snap_position: Vector2 = position + left_grab_offset
	var right_snap_position: Vector2 = position + right_grab_offset
	
	var in_left_snap_range: bool = (
		abs(Game.player.position.x - left_snap_position.x) < grab_width
		and (left_snap_position.y - Game.player.position.y) < grab_height
	)
	var in_right_snap_range: bool = (
		abs(Game.player.position.x - right_snap_position.x) < grab_width
		and (right_snap_position.y - Game.player.position.y) < grab_height
	)
	var in_snap_range: bool = in_left_snap_range or in_right_snap_range

	# Check for player grab
	if not player_grabbed:
		if in_snap_range and Game.player.position.y < position.y:
			if in_left_snap_range:
				grab_direction = Enums.Direction.LEFT
			else:
				grab_direction = Enums.Direction.RIGHT

			grab_player(grab_direction)
	
	# Move player towards coffin
	if player_grabbed:
		var snap_position: Vector2 = (
			left_snap_position
			if grab_direction == Enums.Direction.LEFT else
			right_snap_position
		)

		Game.player.position = lerp(
			snap_position, 
			Game.player.position, 
			exp(- delta * 8.0))


# Grab the player, end the game
func grab_player(direction: Enums.Direction) -> void:
	player_grabbed = true
	Game.victory = true
	Game.countdown.stop()
	if Game.menu != null: Game.menu.go_to(&"PostLevelMenu")
	SFX.play(SFX.ENTER_COFFIN)
	Game.player.enter_coffin(direction)

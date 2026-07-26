extends Node2D

@onready var back_effect: Sprite2D = %BackEffect


var t = 0.0
var player_grabbed: bool = false
var grab_width: float = 40
var grab_height: float = 40
var position_offset: Vector2 = Vector2(50, -24)


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

	var target_position: Vector2 = position + position_offset
	
	# Check for player grab
	if not player_grabbed:
		if (
			abs(Game.player.position.x - target_position.x) < grab_width and
			target_position.y - Game.player.position.y < grab_height and 
			Game.player.position.y < target_position.y
			
		):
			grab_player()
	
	# Move player towards coffin
	if player_grabbed:
		Game.player.position = lerp(
			target_position, 
			Game.player.position, 
			exp(- delta * 8.0))


# Grab the player, end the game
func grab_player() -> void:
	player_grabbed = true
	Game.victory = true
	Game.countdown.stop()
	if Game.menu != null: Game.menu.go_to(&"PostLevelMenu")
	SFX.play(SFX.ENTER_COFFIN)
	Game.player.enter_coffin()

extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement()
#	if Player.last_dir == Vector2(1,0):
#		Player.AniPlayer.play("MoveR")
#	if Player.last_dir == Vector2(-1,0):
#		Player.AniPlayer.play("MoveL")
#=======================================
#State - Change conditions	
#=======================================
	if Player.crouch_input:
		return STATES.CROUCH
	if Player.velocity.x == 0:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.IDLE
	if Player.velocity.y < 0:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.FALL
#		Player.AniPlayer.stop(false)#keep_state:
	if Player.jump_input_activation == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.JUMP
	if Player.dash_input == true and Player.can_dash == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.DASH
	if Input.is_action_pressed("RUN"):
		return STATES.RUN
	return null	
	




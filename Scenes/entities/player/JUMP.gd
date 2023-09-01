extends "state.gd"

func update(delta):
	Player.gravity(delta)
	player_movement()
#	var jump_dir = Player.movement_input
#	if Player.movement_input == null:
#		jump_dir = Vector2.RIGHT
#
#=======================================
#State - Change conditions	
#=======================================	
	if Player.velocity.y > 0:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.FALL
#		Player.AniPlayer.stop(false)#keep_state:
	if Player.dash_input == true and Player.can_dash == true  and Player.can_airdash == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.DASH
#		Player.AniPlayer.stop(false)#keep_state:
	if Player.JumpCount < Player.JumpLimit:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.FALL
	if Player.is_on_floor():
		return STATES.IDLE
	return null
func enter_state():
#	if Player.last_dir == Vector2(1,0):
#		Player.AniPlayer.play("PreJumpR")
#	if Player.last_dir == Vector2(-1,0):
#		Player.AniPlayer.play("PreJumpL")
	Player.velocity.y = Player.JUMP_VELOCITY
	

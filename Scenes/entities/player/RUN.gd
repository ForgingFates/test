extends "state.gd"
func enter_state(): 
	Player.SPEED = Player.RUNSPEED
func update(delta):
	Player.gravity(delta)
	player_movement()
#State - Change conditions	
#=======================================
	if Player.crouch_input:
		return STATES.CROUCH
	if Player.velocity.x == 0:
		return STATES.IDLE
	if Player.velocity.y < 0:
		return STATES.FALL
	if Player.jump_input_activation == true:
		return STATES.JUMP
	if Player.dash_input == true and Player.can_dash == true:
		return STATES.DASH
		
	return null	
func exit_state():
	Player.SPEED = 70.00

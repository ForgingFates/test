extends "state.gd"
@onready var idle_dir = Vector2.ZERO
func enter_state(): 
	idle_dir = Player.last_dir
	#reset to standing if crouching
	Player.IDLE_Cshape.disabled = false
	Player.CROUCH_Cshape.disabled = true
	Player.velocity = Vector2.ZERO#assures if you are in the idle state you are not moving.
	#resets dash and jump so that touching the ground refreshes those abilities. (i'm pretty sure you always go to idle before you move
	Player.DashCount = 0
	Player.can_dash = true
	Player.JumpCount = 0
	Player.can_jump= true
	
func update(delta):
	if idle_dir == Vector2.RIGHT:
		Player.HBpos = Vector2(13,6)#more hitbox pos edgecase stuff. I wonder if there was a more efficient way
	
	if idle_dir == Vector2.LEFT:
		Player.HBpos = Vector2(-13,6)#hitbox positioning edgecase
	Player.gravity(delta)
#=======================================
#State - Change conditions	
#=======================================
	if Player.crouch_input_activation == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.CROUCH
	if Player.movement_input.x != 0:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.MOVE
	if Player.jump_input_activation == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.JUMP
	if Player.velocity.y >0:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.FALL
	if Player.dash_input == true and Player.can_dash == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.DASH
	return null

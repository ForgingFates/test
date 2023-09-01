extends "state.gd"
#=======================================
#Variables
#=======================================
@export var climb_speed = 50
@export var slide_friction = 0.7
#=======================================
#A.K.A Wall Slide
#=======================================
func enter_state():
	pass
  
func update(delta):
	slide_movement(delta)
	if Player.get_next_to_wall() != null:
		Player.JumpCount -=1
	if Player.get_next_to_wall() == null:
		return STATES.FALL
	if Player.jump_input_activation == true:
		return STATES.JUMP
	if Player.is_on_floor():
		return STATES.IDLE
	return null
func slide_movement(delta):
	pass
	if Player.climb_input == true:# I am either going to remove this feature or add it as its own state.
		#I dont like that you slide down if you dont press up. i want to lean towards something closer to celeste.
		#It probably can be done here but it would be more understandable if i seperated it.
		if Player.movement_input.y < 0:
			Player.velocity.y = -climb_speed
		elif Player.movement_input.y > 0:
			Player.velocity.y = climb_speed * 4
	else:
		Player.gravity(delta)
		player_movement()
		Player.velocity.y *= slide_friction
			
#=======================================
#State - Change conditions	
#=======================================	
	



extends Node

#=======================================
#State - Create Variables To Connect nodes
#=======================================
var STATES = null
var Player = null
#=======================================
# Not In Use?
#=======================================
func enter_state():
	pass
func exit_state():
	pass
func update(_delta):
	return null
#=======================================
#Movement - Calculate Movement
#=======================================
func player_movement():
	if Player.prev_state != STATES.DASH:
		if Player.movement_input.x > 0:
			Player.velocity.x = Player.SPEED
			Player.last_dir = Vector2.RIGHT
		elif Player.movement_input.x <0:
			Player.velocity.x = -Player.SPEED
			Player.last_dir = Vector2.LEFT
		else:
			Player.velocity.x = 0
	if Player.prev_state == STATES.DASH:
		Player.velocity.x = STATES.DASH.dash_speed * STATES.DASH.dash_dir.x

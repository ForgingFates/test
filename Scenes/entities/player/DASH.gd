extends "state.gd"
var dash_dir = Vector2.ZERO
var dash_speed = 240
var dashing = false

@export var dash_duration = 0.2
@onready var DashDuration_timer = $DashDuration
func enter_state():
	print(Player.velocity)
	if Player.DashCount < Player.DashLimit:
		Player.DashCount += 1 
		Player.can_dash = false
	dashing = true
	DashDuration_timer.start(dash_duration)
	if Player.movement_input != Vector2.ZERO:
		dash_dir = Player.movement_input
	else:
		dash_dir = Player.last_dir
	Player.velocity = dash_dir.normalized() * dash_speed
#=======================================
#State - Change conditions	
#=======================================
func update(_delta):
	if Player.jump_input_activation == true:
		dashing = false

# Calculate total jump velocity including dash momentum
		var total_jump_velocity = Vector2(dash_dir.x * dash_speed, Player.JUMP_VELOCITY)

# Apply the total jump velocity to the player's velocity
		Player.velocity = total_jump_velocity

		return STATES.JUMP

	if !dashing:
		return STATES.FALL

	return null
	
	
func exit_state():
	dashing = false
#	Player.AniPlayer.stop(false)#keep_state:
func _on_timer_timeout():
	dashing = false

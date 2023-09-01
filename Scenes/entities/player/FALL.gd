extends "state.gd"

@onready var coyote_timer = $CoyoteTimer
@export var coyote_duration = 0.2


func enter_state():
#	var fall_dir = Player.jump_dir
#	fall_dir = Player.movement_input
#	if fall_dir == Vector2.LEFT:
#		Player.AniPlayer.play("FallL")
#	if fall_dir == Vector2.RIGHT:
#		Player.AniPlayer.play("FallR")
		
		
	if Player.prev_state == STATES.IDLE or Player.prev_state == STATES.MOVE\
	or Player.prev_state == STATES.SLIDE:
		if Player.JumpCount <= Player.JumpLimit:
			Player.can_jump = true
			coyote_timer.start(coyote_duration)
		
		
			
	
	
func update(delta):
	player_movement()
	Player.gravity(delta)
#=======================================
#State - Change conditions	
#=======================================
	if Player.is_on_floor():
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.IDLE
#		Player.AniPlayer.stop(false)#keep_state:
	if Player.dash_input == true and Player.can_dash == true and Player.can_airdash == true:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.DASH
	if Player.get_next_to_wall() != null:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.SLIDE
	if Player.jump_input_activation and Player.can_jump:
#		Player.AniPlayer.stop(false)#keep_state:
		return STATES.JUMP
	return null
	






func _on_timer_timeout():
	Player.JumpCount = Player.JumpLimit

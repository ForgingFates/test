extends "state.gd"
var crouch_speed = 30
var crouch_dir = Vector2.RIGHT
func enter_state():
	Player.IDLE_Cshape.disabled = true
	Player.CROUCH_Cshape.disabled = false
	crouch_dir = Player.last_dir
	if crouch_dir == Vector2.RIGHT:
		Player.HBpos = Vector2(19,19)
	if crouch_dir == Vector2.LEFT:
		Player.HBpos = Vector2(-19,19)
	
func update(_delta):
	#=================================================
	#edgecase - assures last direction changes properly while crouched
	#================================================
	if Input.is_action_just_pressed("MoveLeft"):
		Player.last_dir = Vector2.LEFT
	if Input.is_action_just_pressed("MoveRight"):
		Player.last_dir = Vector2.RIGHT
	#===============================================
	if Player.movement_input != Vector2.ZERO:
		crouch_dir = Player.movement_input
	else:
		crouch_dir = Vector2.ZERO
	Player.velocity = crouch_dir.normalized()  * crouch_speed
	if Player.crouch_input == false and Player.get_next_to_ceiling() != true:
		return STATES.IDLE
	if not Player.is_on_floor():
		return STATES.FALL
	return null
#func exit_state(delta):
#	pass

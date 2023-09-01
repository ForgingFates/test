extends CharacterBody2D
#============================================
#Raycast - Source (Used for collision detection.)
#============================================
@onready var Raycasts = $Raycasts #used for slide 
@onready var RayRoof = $RayRoof #used for edgecase to prevent player from changing from crouch to standing until it is safe to do so.

#============================================
#Player - Health and damage
#============================================
@onready var HBpos: Vector2 #made so the hitbox position can be modified outside this script easier
@onready var HITBOX = $HITBOX
@onready var atk_cd = false #prevents attack spam
@onready var enemy_in_range = false #assist in enemy damage calculation(the only thing that keeps the player from instantly dying is the enemies attack cooldown
#============================================
#Collision - Shape
#============================================
@onready var Cshape = CollisionShape2D
@onready var IDLE_Cshape = $IDLE_Cshape
@onready var CROUCH_Cshape = $CROUCH_Cshape

#============================================
#Gravity - Source
#============================================
var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var Arealabel = $Arealabel

#============================================
#Player - Input
#============================================
var movement_input = Vector2.ZERO
var jump_input = false
var jump_input_activation = false
var climb_input = false
var dash_input = false
var crouch_input = false
var crouch_input_activation = false
#============================================
#Player Movement - Variables
#============================================
var SPEED = 70.00
const RUNSPEED = 140.00
const JUMP_VELOCITY = -400.0
var last_dir = Vector2.RIGHT
var cur_dir = Input.get_axis("MoveLeft", "MoveRight")
#============================================
#Mechanics
#============================================
var can_airdash:bool 
var DashCount:int = 0
var DashLimit:int = 1
var JumpCount:int = 0
var JumpLimit:int = 1
var can_dash:bool = true
var can_jump:bool = true
var jump_dir:Vector2 = Vector2.ZERO
#============================================
#States
#============================================
var current_state = null 
var prev_state = null
#============================================
#State Machine - Source Reference
#============================================
@onready var STATES = $STATES
@onready var IDLE = $STATES/IDLE
@onready var MOVE = $STATES/MOVE
@onready var JUMP = $STATES/JUMP
@onready var FALL = $STATES/FALL
@onready var SLIDE = $STATES/SLIDE
@onready var CROUCH = $STATES/CROUCH
@onready var RUN = $STATES/RUN
#================================================
#State Machine - Connect state.gd to the STATES.gd to access its children.
#================================================
func _ready():
	for state in STATES.get_children():
		state.STATES = STATES
		state.Player = self 

#================================================
#State Machine - Default States
#================================================
	current_state = STATES.IDLE
	prev_state = STATES.IDLE
#================================================
#Physics - Process Inputs and States
#================================================
func _physics_process(delta):
	Hbox(HBpos)
	player_input()
	(player_input())
	change_state(current_state.update(delta))
	$Label.text = str(current_state.get_name())
	move_and_slide()
	damage()
	gameover()
#================================================
#Gravity - Define Use Conditions
#================================================
func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta
	
	
	#====================================
	


	# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	
		var direction = Input.get_axis("MoveLeft", "MoveRight")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
#================================================
#State Machine - Change Source
#================================================
func change_state(input_state):
	if input_state != null:
		prev_state = current_state
		current_state = input_state
	
		prev_state.exit_state()
		current_state.enter_state()
#================================================
#Player Movement - Input
#================================================
func player_input():		
	#=============================================
	#Directional Input- also includes hitbox positioning
	#=============================================
	movement_input = Vector2.ZERO
	if Input.is_action_pressed("MoveRight"):
		movement_input.x += 1
		if current_state != STATES.CROUCH:
			HBpos = Vector2(13,6)
		else:
			HBpos = Vector2(19,19)
			
	if Input.is_action_pressed("MoveLeft"):
		movement_input.x -= 1
		if current_state != STATES.CROUCH:
			HBpos = Vector2(-13,6)
			
		else:
			HBpos = Vector2(-19,19)
			
		
	if Input.is_action_pressed("MoveUp"):
		movement_input.y -= 1
	if Input.is_action_pressed("MoveDown"):
		movement_input.y += 1
		
 #==============================================
	# Mechanics - jumping
	#==============================================
	if JumpCount == JumpLimit:
		can_jump = false

	# Check if the jump input is pressed, regardless of other buttons.
	if Input.is_action_just_pressed("Jump"):
		jump_input_activation = true
		JumpCount += 1
	else:
		jump_input_activation = false

	# Check if the jump input is held and the player is on the ground or climbing.
	if (Input.is_action_pressed("Jump") or Input.is_action_pressed("Jump") and Input.is_action_pressed("run")) and (is_on_floor() or climb_input):
		jump_input = true
	else:
		jump_input = false
	#==============================================
	#Mechanics - climbing
	#==============================================
	
	if Input.is_action_pressed("Climb"):
		climb_input = true
	else:
		climb_input = false
	#==============================================
	#Mechanics - dashing
	#==============================================
	if Input.is_action_just_pressed("Dash"):
		dash_input = true
	else:
		dash_input = false	
	if DashCount == DashLimit:
		can_dash = false
	#==============================================
	#Mechanics - crouching
	#==============================================
	if Input.is_action_pressed("Crouch"):
		crouch_input = true
	else:
		crouch_input = false
	if Input.is_action_just_pressed("Crouch"):
		crouch_input_activation = true
	else:
		crouch_input_activation = false
	#==============================================
	#Mechanics - Running
	#==============================================
	if Input.is_action_pressed("RUN"):
		print("debug run pressed")
	#==============================================
	#Mechanics - Attacking
	#==============================================
	
	if Input.is_action_just_pressed("Attack") and atk_cd == false:
		attack()
#============================================
#Mechanic - Wall Detection ((Checks To See If Rays Detect A Collision)
#It Does This By Getting The Children Of The Raycast Node.
#It Checks If The Colliding direction 
#Is Left Or Right Based On Which Rays Collided)
#============================================
#Purpose - To Allow Sliding To Occur Slightly Outside The Player Hitbox
#This Allows The Player To Slide Over The Edge Of A Corner More Smoothly
#In Theory.
#============================================
func get_next_to_wall():
	for raycast in Raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.x < 0:
				return Vector2.RIGHT
			else:
				return  Vector2.LEFT
	return null
func get_next_to_ceiling():
	for raycast in RayRoof.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.target_position.y < 0:
				return true
	return null
func  Hbox(newpos:Vector2):
	newpos = HBpos
	HITBOX.position = newpos
func player():
	pass
func damage():
	if enemy_in_range == true:
		Global.playerhealth = Global.playerhealth - Global.enemydmg
func _on_hurtbox_body_entered(body):
	print("no method detected")
	if body.has_method("enemy"):
		enemy_in_range = true
func _on_atk_cd_timeout():
	atk_cd = false
func _on_hitframes_timeout():
	$HITBOX/CollisionShape2D.disabled = true
func attack():
	$HITBOX/CollisionShape2D.disabled = false
	$hitframes.start()
	atk_cd = true
	$atk_cd.start()
func gameover():
	if Global.playerhealth <= 0:
		queue_free()

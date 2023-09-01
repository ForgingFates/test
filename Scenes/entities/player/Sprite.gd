extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if Input.is_action_pressed("MoveLeft"):
		flip_h = true
	elif Input.is_action_pressed("MoveRight"):
		flip_h = false

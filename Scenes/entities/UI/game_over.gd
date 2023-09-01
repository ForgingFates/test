extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reload_pressed():
	#need to create a save and load system first
	pass # Replace with function body.


func _on_quit_pressed():#quits games
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()

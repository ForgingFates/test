extends Node2D
@onready var sec_1 = $sec1

@onready var player = $Player
@onready var sec1 = preload("res://Scenes/entities/enemies/sec_1.tscn")
#Death screen
func _process(delta):
	if Global.playerhealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/entities/UI/game_over.tscn")


func _on_the_trail_of_spikes_body_entered(body):
	if body.has_method("player"):
		if Global.prev_zone == "sec1":
			Global.cur_zone = "sec2"
			Global.prev_zone = Global.cur_zone
			player.Arealabel.text = ("The Trail of Spikes")
			if !player.Arealabel.visible:
				player.Arealabel.show()
				$"text timer".start()
			despawnsec1()
		elif Global.prev_zone == "sec2":
			Global.cur_zone = "sec1"
			Global.prev_zone = Global.cur_zone
			player.Arealabel.text = ("The Proving Grounds")
			if !player.Arealabel.visible:
				player.Arealabel.show()
				$"text timer".start()
			respawnsec1()
	else:
		return null
func _on_text_timer_timeout():
	if player.Arealabel.visible:
		player.Arealabel.hide()
##func despawnsec1():
#	var enemy = get_tree().get_children()
#	for child in enemy:
#		if is_instance_of($sec1,Node):
#			queue_free()
#
func respawnsec1():
	var instance = sec1.instantiate()
	instance.name = "Sec1Instance"#names instances for deletion in despawn fuction
	call_deferred("add_child", instance) #was throwing errors saying i should do this
	


func despawnsec1():
	if sec_1 != null and sec_1.is_inside_tree():#checks to make sure sec is not null and inside the tree didnt work if i didnt check null
		sec_1.queue_free()
	for child in get_children(): # for each child checks the child name to see if it should be deleted
		if child.name == "Sec1Instance":
			child.call_deferred("queue_free")#godot wanted it when i spawned them in i just added it here too





extends RigidBody2D
@onready var speed = 100
@onready var target
@onready var player_in_range = false
@onready var attack_cd = false
@onready var is_alive = true
@onready var health = 20
func sec1():#has_method()
	pass
func enemy():# used for all instances of has_method("enemy")
	pass

func _ready():
	pass


func _process(delta):
	enemydmg()
	death()
	follow_player(delta)



func _on_hitbox_body_entered(body):#detects if the player is in range
	if body.has_method("player"):
		player_in_range = true


func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
func enemydmg():#handles damage by applying a cooldown between ticks of damage
	if player_in_range == true and attack_cd == false:
		Global.playerhealth = Global.playerhealth - 5
		attack_cd = true
		$atkCD.start()
		
func follow_player(delta):
	if target:
		var direction = target.global_position - global_position
		direction = direction.normalized()
		global_position += direction * speed * delta


func _on_atk_cd_timeout():
	attack_cd = false
func death():
	if health <= 0:
		queue_free()


func _on_hurtbox_area_entered(area):
	if area.has_method("hit"):
		health = health - Global.playerdmg
		print(health)


func _on_enemy_vision_body_entered(body):
	if body.has_method("player"):
		print("entered")
		target = body


func _on_enemy_vision_body_exited(body):
	if body.has_method("player"):
		print("exited")
		target = null

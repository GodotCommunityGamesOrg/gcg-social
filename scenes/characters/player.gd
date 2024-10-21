extends CharacterBody2D
class_name Player

const SPEED = 300.0

func _physics_process(delta):
	var peer_id = name.to_int()
	set_multiplayer_authority(peer_id)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	move_and_slide()

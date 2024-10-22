extends CharacterBody2D
class_name Player

const SPEED = 300.0

func _ready() -> void:
	give_control_to_the_proper_client()
	if this_is_my_player():
		follow_it_with_a_camera()

func _physics_process(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	move_and_slide()

func get_peer_id() -> int:
	return name.to_int()

func this_is_my_player() -> bool:
	var the_clients_peer_id = multiplayer.get_unique_id()
	var this_players_peer_id = get_peer_id()
	return the_clients_peer_id == this_players_peer_id

func give_control_to_the_proper_client() -> void:
	var peer_id = get_peer_id()
	set_multiplayer_authority(peer_id) # Setting the multiplayer authority tells the engine which peer is in charge of this node

func follow_it_with_a_camera() -> void:
	var camera = Camera2D.new()
	add_child(camera)

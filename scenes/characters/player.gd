extends CharacterBody2D
class_name Player

## The speed of the player
@export var SPEED = 300.0

func _ready() -> void:
	give_control_to_the_proper_client()
	if this_is_my_player():
		follow_it_with_a_camera()

func _physics_process(delta) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED
	move_and_slide()

## Returns the peer id of the client that is in control of this player
func get_peer_id() -> int:
	return name.to_int()

## Checks whether this player belongs to this client
func this_is_my_player() -> bool:
	var the_clients_peer_id = multiplayer.get_unique_id()
	var this_players_peer_id = get_peer_id()
	return the_clients_peer_id == this_players_peer_id

## Gives control of this player to the client that owns it
func give_control_to_the_proper_client() -> void:
	var peer_id = get_peer_id()
	set_multiplayer_authority(peer_id) # Setting the multiplayer authority tells the engine which peer is in charge of this node

## Adds a camera 2D to this player
func follow_it_with_a_camera() -> void:
	var camera = Camera2D.new()
	add_child(camera)

## Destroys this player
func eat_me() -> void:
	queue_free()

extends Node2D
class_name Players

signal username_available(peer_id: int)
signal username_unavailable(peer_id: int)

const PLAYER_FACTORY = preload("res://scenes/characters/player.tscn")

## Adds a Player to this node and sets its peer id
func add_player_to_scene(peer_id: int, username: String) -> void:
	if !OS.has_feature("is_server"):
		return
	var player: Player = PLAYER_FACTORY.instantiate()
	player.set_name(str(peer_id))
	player.set_username(username)
	add_child(player)

func remove_player_from_scene(peer_id: int) -> void:
	var player: Player = get_node(str(peer_id))
	if player:
		remove_child(player)
		player.eat_me()

func _on_multiplayer_connection_client_disconnected(peer_id: int) -> void:
	remove_player_from_scene(peer_id)

func _on_player_login_username_requested(peer_id: int, username: String) -> void:
	var children = get_children()
	for child in children:
		if child is Player and child.username == username:
			username_unavailable.emit(peer_id)
			return
	add_player_to_scene(peer_id, username)
	username_available.emit(peer_id)

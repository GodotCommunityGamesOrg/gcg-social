extends Node2D
class_name Players

const PLAYER_FACTORY = preload("res://scenes/characters/player.tscn")

## Adds a Player to this node and sets its peer id
func add_player_to_scene(peer_id: int) -> void:
	if !OS.has_feature("is_server"):
		return
	var player: Player = PLAYER_FACTORY.instantiate()
	player.set_name(str(peer_id))
	add_child(player)

func remove_player_from_scene(peer_id: int) -> void:
	var player: Player = get_node(str(peer_id))
	remove_child(player)
	player.eat_me()

func _on_multiplayer_connection_client_connected(peer_id: int) -> void:
	add_player_to_scene(peer_id)

func _on_multiplayer_connection_client_disconnected(peer_id: int) -> void:
	remove_player_from_scene(peer_id)

extends Node

signal client_connected(peer_id: int)
signal client_disconnected(peer_id: int)
@onready var host_input: TextEdit = $HostInput
@onready var connect_btn: Button = $ConnectBtn
@onready var disconnect_btn: Button = $DisconnectBtn
var multiplayer_peer = ENetMultiplayerPeer.new()
var url: String = "127.0.0.1"
const PORT: int = 9009

func _ready():
	update_connection_buttons()
	if OS.has_feature("is_server"):
		setup_server_connection()
	else:
		setup_client_connection()

func setup_server_connection():
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(_on_client_connected)
	multiplayer_peer.peer_disconnected.connect(_on_client_disconnected)

func _on_client_connected(new_peer_id : int) -> void:
	await get_tree().create_timer(1).timeout
	client_connected.emit(new_peer_id)
	update_connection_buttons()

func _on_client_disconnected(leaving_peer_id : int) -> void:
	await get_tree().create_timer(1).timeout
	client_disconnected.emit(leaving_peer_id)
	update_connection_buttons()

func setup_client_connection():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_connected_to_server():
	if OS.has_feature("is_server"):
		return
	update_connection_buttons()

func _on_server_disconnected():
	if OS.has_feature("is_server"):
		return
	multiplayer_peer.close()
	update_connection_buttons()

func update_connection_buttons() -> void:
	if OS.has_feature("is_server"):
		host_input.text = "I'm a dedicated server. Ignore me!"
		host_input.hide()
		connect_btn.disabled = true
		connect_btn.hide()
		disconnect_btn.disabled = true
		disconnect_btn.hide()
		return
	
	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_DISCONNECTED:
		connect_btn.disabled = false
		disconnect_btn.disabled = true
	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTING:
		connect_btn.disabled = true
		disconnect_btn.disabled = true
	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTED:
		connect_btn.disabled = true
		disconnect_btn.disabled = false

func _on_connect_btn_pressed() -> void:
	var url = host_input.text
	multiplayer_peer.create_client(url, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	update_connection_buttons()

func _on_disconnect_btn_pressed():
	var peer_id = multiplayer_peer.get_unique_id()
	multiplayer_peer.close()
	update_connection_buttons()

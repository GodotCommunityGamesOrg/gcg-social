extends Control
class_name MultiplayerConnection

## [server only] Emitted when a client connects to the server
signal client_connected(peer_id: int)

## [server only] Emitted when a client disconnects from the server
signal client_disconnected(peer_id: int)

var multiplayer_peer = ENetMultiplayerPeer.new()
var url: String = "127.0.0.1"
const PORT: int = 9009

@onready var host_input: TextEdit = $Connect/Details/HostInput
@onready var connect_btn: Button = $Connect/Buttons/ConnectBtn
@onready var disconnect_btn: Button = $DisconnectBtn
@onready var main_menu: Control = $"../MainMenu"
@onready var server_label: Label = $"../ServerLabel"
@onready var back: Button = $Connect/Buttons/Back

func _ready() -> void:
	update_connection_buttons()
	if OS.has_feature("is_server"):
		setup_server_connection()
		$Connect.hide()
		$Background.hide()
		main_menu.hide()
		server_label.show()
	else:
		setup_client_connection()

## [server only] Sets up the Multiplayer Server
func setup_server_connection() -> void:
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(_on_client_connected)
	multiplayer_peer.peer_disconnected.connect(_on_client_disconnected)

## [server only] Called on the server when a client connects to the server
func _on_client_connected(new_peer_id : int) -> void:
	client_connected.emit(new_peer_id)
	update_connection_buttons()

## [server only] Called on the server when a client disconnects from the server
func _on_client_disconnected(leaving_peer_id : int) -> void:
	client_disconnected.emit(leaving_peer_id)
	update_connection_buttons()

## [client only] Sets up the Multiplayer Client
func setup_client_connection() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

## [client only] Called on the client when it connects to the server
func _on_connected_to_server() -> void:
	if OS.has_feature("is_server"):
		return
	update_connection_buttons()

## [client only] Called on the client when it disconnects from the server
func _on_server_disconnected() -> void:
	if OS.has_feature("is_server"):
		return
	multiplayer_peer.close()
	update_connection_buttons()

## Updates the connection UI based on the connection status
func update_connection_buttons() -> void:
	# if this is the server we don't need to show any connection UI
	if OS.has_feature("is_server"):
		host_input.text = "I'm a dedicated server. Ignore me!"
		host_input.hide()
		connect_btn.disabled = true
		connect_btn.hide()
		disconnect_btn.disabled = true
		disconnect_btn.hide()
		return

	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_DISCONNECTED:
		$Connect.show()
		$Background.show()
		back.show()
		connect_btn.disabled = false
		disconnect_btn.disabled = true
	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTING:
		back.hide()
		connect_btn.disabled = true
		disconnect_btn.disabled = true
	if multiplayer_peer.get_connection_status() == multiplayer_peer.CONNECTION_CONNECTED:
		back.hide()
		$Connect.hide()
		$Background.hide()
		connect_btn.disabled = true
		disconnect_btn.disabled = false

## [client only] Called on the client when the connect button is pressed
func _on_connect_btn_pressed() -> void:
	url = host_input.text
	multiplayer_peer.create_client(url, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	update_connection_buttons()

## [client only] Called on the client when the disconnect button is pressed
func _on_disconnect_btn_pressed() -> void:
	multiplayer_peer.close()
	main_menu.show()
	update_connection_buttons()


func _on_back_pressed() -> void:
	main_menu.show()
	pass

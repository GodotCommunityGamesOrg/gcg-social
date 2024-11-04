# Auto Login Service for development purposes...because it's annoying to keep logging in multiple windows

# INSTRUCTIONS: Change the AUTO_LOGIN constant on line 23 to true/false in order to turn auto-login on/off.


# Development Steps:
# 1. Simulate clicking "Login" button on MainMenu scene.
# 2. Simulate clicking "Connect" button on MultiplayerConnection scene to connect to the server ip.
# 3. Move server window to upper left corner of screen for convenience.
# 4. User peer_id's of clients to position client windows separately. Need to send client's peer_id's to the server and have the server send back the order in which each client connected.
# 5. Simulate typing in the username and clicking "Join" button in PlayerLogin scene.


extends Node


@onready var multiplayer_connection_node: MultiplayerConnection = get_node("/root/Main/HUD/MultiplayerConnection")
@onready var main_menu_node: Control = get_node("/root/Main/HUD/MainMenu")
@onready var player_login_node: Control = get_node("/root/Main/HUD/PlayerLogin")


## CHANGE THIS VALUE TO TURN AUTO LOGIN ON/OFF
const AUTO_LOGIN: bool = true


var num_of_client_peer_ids_server_has_received: int = 0


func _ready():
	if AUTO_LOGIN:
		multiplayer_connection_node.connect("ready", start_setup)


func start_setup():
	if OS.has_feature("is_server"):
		# (Step #3) set position of server window on screen
		tween_window_position(Vector2.ZERO, 0.3, 0.2)

		get_window().set_title("gcg-social Server")
	else:
		# (Step #1) simulate "Login" button press in MainMenu scene
		main_menu_node.hide()

		# (Step #2) simulate "Connect" button press in MultiplayerConnection scene, this is where clients get their peer_id
		multiplayer_connection_node._on_connect_btn_pressed()

		# get necessary data to log player in
		var peer_id = multiplayer.multiplayer_peer.get_unique_id()
		var username: String = "Player" + str(randi_range(1,10000))

		get_window().set_title("gcg-social Client - " + username)

		# (Step #4a) move client windows to separate spots on screen
		var timer = get_tree().create_timer(2.0)
		timer.connect("timeout", continue_setup.bind(peer_id, username))


# Client makes rpc call to server, sending client's peer_id to server
# And logs in player
func continue_setup(peer_id: int, username: String):
	# (Step #4b) move client windows to separate spots on screen
	rpc_id(MultiplayerPeer.TARGET_PEER_SERVER, "send_client_peer_id_to_server", peer_id)

	login_player(peer_id, username)


# (Step #5) simulate "Join" button pressed in PlayerLogin scene
func login_player(peer_id: int, username: String):
	player_login_node.request_username(peer_id, username)
	player_login_node.get_node("Login/MarginContainer/UsernameLine/UsernameInput").text = username
	player_login_node._on_login_btn_pressed()


# (Step #4c) move client windows to separate spots on screen
# Make rpc call from server to client to tell the client in which order the client connected.
@rpc("any_peer")
func send_client_peer_id_to_server(peer_id: int) -> void:
	print("peer ", multiplayer.multiplayer_peer.get_unique_id(), " (server), received peer id ", peer_id, " from client.")

	rpc_id(peer_id, "set_client_window_position", num_of_client_peer_ids_server_has_received)
	num_of_client_peer_ids_server_has_received += 1


# (Step #4d)
# set each client window position with a tween
@rpc("any_peer")
func set_client_window_position(client_order_num: int):
	var x_pos_for_window: int = DisplayServer.screen_get_usable_rect().size.x - get_window().size.x
	var y_pos_for_window: int = (client_order_num * get_window().get_size_with_decorations().y) if client_order_num < 2 else (DisplayServer.screen_get_usable_rect().size.y - get_window().size.y)

	tween_window_position(Vector2(x_pos_for_window, y_pos_for_window), 0.2)


func tween_window_position(target_pos: Vector2, duration: float, delay: float = 0.0):
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(get_window(), "position:x", target_pos.x, duration).set_delay(delay)
	tween.tween_property(get_window(), "position:y", target_pos.y, duration).set_delay(delay)

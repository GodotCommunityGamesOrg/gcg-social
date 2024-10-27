extends Control

signal username_requested(peer_id: int, username: String)

@rpc("any_peer")
func request_username(peer_id: int, username: String) -> void:
	if !OS.has_feature("is_server"):
		return
	username_requested.emit(peer_id, username)

@rpc("authority")
func username_unavailable() -> void:
	$Login/ErrorMessage.text = "That username is taken"
	$Login/ErrorMessage.show()

@rpc("authority")
func username_available() -> void:
	hide()

func _on_players_username_unavailable(peer_id: int) -> void:
	rpc_id(peer_id, "username_unavailable")

func _on_players_username_available(peer_id: int) -> void:
	print("username_available")
	rpc_id(peer_id, "username_available")


func _on_login_btn_pressed() -> void:
	var peer_id = multiplayer.get_unique_id()
	var username: String = $Login/MarginContainer/UsernameLine/UsernameInput.text
	if username.length() < 4:
		$Login/ErrorMessage.text = "Username must be at least 4 characters long."
		$Login/ErrorMessage.show()
	elif username.length() > 10:
		$Login/ErrorMessage.text = "Username cannot be longer than 10 characters"
		$Login/ErrorMessage.show()
	else:
		rpc_id(0, "request_username", peer_id, username)

func _on_username_input_text_changed(new_text: String) -> void:
	$Login/ErrorMessage.text = ""
	$Login/ErrorMessage.hide()

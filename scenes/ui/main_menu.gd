extends Control

@onready var options_menu: Control = $"../OptionsMenu"
@onready var credits_menu: Control = $"../CreditsMenu"

## Hides the main_menu, showing the MultiplayerConnection control node
func _on_connect_pressed() -> void:
	hide()
	pass

## Make the options menu visible
func _on_options_pressed() -> void:
	options_menu.show()
	pass

## Make the credits menu visible
func _on_credits_pressed() -> void:
	credits_menu.show()
	pass

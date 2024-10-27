extends Camera2D
class_name ZoomingCamera

## Lower cap for the `zoom`.
@export var min_zoom := 0.5

## Upper cap for the `zoom`.
@export var max_zoom := 2.0

## Controls how much we increase or decrease the `zoom` on every turn of the scroll wheel.
@export var zoom_factor := 0.1

var _zoom_level := 1.0

## Sets the zoom while keeping it between the min and max zoom
func _set_zoom(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	zoom = Vector2(_zoom_level, _zoom_level)

## Zoom the camera in
func zoom_in() -> void:
	_set_zoom(_zoom_level + zoom_factor)

## Zoom the camera out
func zoom_out() -> void:
	_set_zoom(_zoom_level - zoom_factor)

func _unhandled_input(event) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	if event.is_action_pressed("zoom_out"):
		zoom_out()

extends Control

@onready var root_viewport: Viewport = get_tree().get_root().get_viewport()
@onready var snap_transform_pixel: CheckButton = $Options/Snap2DTransformPixel
@onready var v_sync_toggle: CheckButton = $Options/VSync


func _ready() -> void:
	# initialize button states
	var snap_2d_pixel_state : bool = ProjectSettings.get_setting("rendering/2d/snap/snap_2d_transforms_to_pixel")
	snap_transform_pixel.set_pressed_no_signal(snap_2d_pixel_state)
	var vsync_mode = ProjectSettings.get_setting("display/window/vsync/vsync_mode")

	# Virtical Syncronization Mode
	# Note that Adaptive and Mailbox are not usable with the Compatibility render backend.
	if (vsync_mode == DisplayServer.VSYNC_ENABLED):
		v_sync_toggle.set_pressed_no_signal(true)
	else: # DisplayServer.VSYNC_DISABLED, DisplayServer.VSYNC_ADAPTIVE and DisplayServer.VSYNC_MAILBOX
		v_sync_toggle.set_pressed_no_signal(false)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Hide options menu (effectively returning to previous scene state)
func _on_back_button_pressed() -> void:
	hide()
	pass

## Set the 'Snap 2D Transform to Pixel' value for both runtime and project settings.
func _on_snap_2d_transform_pixel_toggled(toggled_on: bool) -> void:
	RenderingServer.viewport_set_snap_2d_transforms_to_pixel(root_viewport.get_viewport_rid(), toggled_on)
	ProjectSettings.set_setting("rendering/2d/snap/snap_2d_transforms_to_pixel", toggled_on)
	pass


func _on_v_sync_toggled(toggled_on: bool) -> void:
	var vsync_mode: DisplayServer.VSyncMode
	if (toggled_on == true):
		vsync_mode = DisplayServer.VSYNC_ENABLED
	else:
		vsync_mode = DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(vsync_mode)
	pass

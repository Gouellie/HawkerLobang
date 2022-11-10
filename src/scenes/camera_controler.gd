extends Camera2D

var zoom_min   : Vector2 = Vector2(0.5, 0.5)
var zoom_max   : Vector2 = Vector2(2.0, 2.0)
var zoom_speed : Vector2 = Vector2(0.2, 0.2)
var desired_zoom : Vector2 = zoom

var mouse_start_pos
var screen_start_position

var dragging = false

func _process(_delta: float) -> void:
	zoom = lerp(zoom, desired_zoom, 0.1)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if desired_zoom > zoom_min:
					desired_zoom -= zoom_speed
			if event.button_index == BUTTON_WHEEL_DOWN:
				if desired_zoom < zoom_max:
					desired_zoom += zoom_speed
	if event.is_action("camera_pan"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position			

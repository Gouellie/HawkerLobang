extends Camera2D

# how far in you can zoom
var zoom_min   : Vector2 = Vector2(0.3, 0.3)
# how far out you can zoom
var zoom_max   : Vector2 = Vector2(3.0, 3.0)
var zoom_speed : Vector2 = Vector2(0.2, 0.2)
var desired_zoom : Vector2 = zoom

var mouse_start_pos
var screen_start_position

var dragging = false
var lerping_to_selection = false

var tracked_entity : Entity


func _ready() -> void:
	Log.log_error(Events.connect("entity_selected", self, "on_entity_selected"))


func _process(_delta: float) -> void:
	zoom = lerp(zoom, desired_zoom, 0.1)
	if lerping_to_selection and is_instance_valid(tracked_entity):
		position = lerp(position, get_tracked_entity_position(), 0.1)


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
		lerping_to_selection = false
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position


func on_entity_selected(entity : Entity) -> void:
	tracked_entity = entity
	if is_instance_valid(entity) :
		lerping_to_selection = true
	else:
		lerping_to_selection = false
		

func get_tracked_entity_position() -> Vector2:
		if not is_instance_valid(tracked_entity) :
			lerping_to_selection = false
			return position
		var offset = OS.window_size
		# don't know how to make it work properly yet
		#offset.x /= 3.0 if Global.is_toolbox_open else 2.0
		#offset.y /= 2.0
		var pos = tracked_entity.global_position - offset / 2.0
		return pos


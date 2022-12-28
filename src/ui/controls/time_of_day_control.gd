extends Control

var _datetime : DateTime
var _current_speed : int = Global.current_speed

var _previous_speed
var _previous_button : TextureButton
var _is_paused_by_key
var simulation_paused : bool = true


onready var time_of_day_speed_label : Label = $HBoxContainer/VBoxContainer/TimeOfDaySpeedLabel
onready var date_label : Label = $HBoxContainer/VBoxContainer/DateLabel
onready var panel_set_date := $Panel_SetDate
onready var datetime_control := $Panel_SetDate/CenterContainer/HBoxContainer/DateTimeControl
onready var pause_button := $HBoxContainer/VBoxContainer/ButtonGroup/TextureButton_Pause
onready var button_group : ButtonGroup

func _ready() -> void:
	Log.log_error(Events.connect("pause_simulation", self, "on_simulation_paused"))	
	Log.log_error(Events.connect("time_updated", self, "on_time_updated"))
	Log.log_error(Events.connect("time_ellapsed", self, "on_time_updated"))
	_update_speed_text()
	button_group = pause_button.group
	_previous_button = button_group.get_pressed_button()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var speed : int = 0
		if not pause_button.pressed:
			_previous_speed = _current_speed
			_previous_button = button_group.get_pressed_button()
			pause_button.pressed = true
		elif _previous_button and _previous_button != pause_button:
			speed = _previous_speed
			_previous_button.pressed = true
		_on_Button_Speed_pressed(speed)


func on_time_updated(p_datetime : DateTime) -> void:
	_datetime = p_datetime
	_display_date()


func _on_Button_Speed_pressed(speed: int) -> void:
	if _current_speed == speed:
		return
	_current_speed = speed
	Events.emit_signal("speed_changed", speed)
	_update_speed_text()


func _update_speed_text() -> void:
	var data_string = "Speed : %sx"
	var text = data_string % str(_current_speed) if _current_speed > 0 else "Paused" 
	if _current_speed < 0 :
		text = "Max"
	time_of_day_speed_label.text = text
	

func _display_date() -> void:
	date_label.text = _datetime.to_string() if not simulation_paused else _datetime.to_string_date_only()


func _on_Button_SetDate_pressed() -> void:
	panel_set_date.visible = true
	datetime_control.update_datetime(Global.current_datetime)


func _on_Button_SetDate_User_pressed(accept : bool) -> void:
	panel_set_date.visible = false
	if accept and datetime_control.datetime :
		Events.emit_signal("update_current_datetime", datetime_control.datetime)


func on_simulation_paused(paused : bool) -> void:
	simulation_paused = paused

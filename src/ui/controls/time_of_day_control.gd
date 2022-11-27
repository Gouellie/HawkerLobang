extends Control

var _datetime : DateTime
var _current_speed : int = 1

var _previous_speed
var _is_paused_by_key


onready var time_of_day_speed_label : Label = $HBoxContainer/VBoxContainer/TimeOfDaySpeedLabel
onready var date_label : Label = $HBoxContainer/VBoxContainer/DateLabel
onready var panel_set_date := $Panel_SetDate
onready var datetime_control := $Panel_SetDate/CenterContainer/HBoxContainer/DateTimeControl

func _ready() -> void:
	Log.log_error(Events.connect("time_ellapsed", self, "_on_time_ellapsed"))
	_update_speed_text()


func _input(event: InputEvent) -> void:

	if event.is_action_pressed("pause"):
		if not _is_paused_by_key:
			_is_paused_by_key = true
			_previous_speed = _current_speed
			_on_Button_Speed_pressed(0)
		else:
			_is_paused_by_key = false
			_on_Button_Speed_pressed(_previous_speed)


func _on_time_ellapsed(p_datetime : DateTime) -> void:
	_datetime = p_datetime
	_display_date()


func _on_Button_Speed_pressed(speed: int) -> void:
	if _current_speed == speed:
		return
	_current_speed = speed
	Events.emit_signal("speed_changed", speed)
	Global.current_speed = speed
	_update_speed_text()


func _update_speed_text() -> void:
	var data_string = "Speed : %sx"
	var text = data_string % str(_current_speed) if _current_speed > 0 else "Paused" 
	if _current_speed < 0 :
		text = "Max"
	time_of_day_speed_label.text = text
	

func _display_date() -> void:
	date_label.text = _datetime.to_string()


func _on_Button_SetDate_pressed() -> void:
	panel_set_date.visible = true
	datetime_control.update_datetime(Global.current_datetime)


func _on_Button_SetDate_User_pressed(accept : bool) -> void:
	panel_set_date.visible = false
	if accept and datetime_control.datetime :
		Events.emit_signal("update_current_datetime", datetime_control.datetime)

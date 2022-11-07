extends Control

signal entry_deleted(time_span)
signal apply_changes(time_span)

export (bool) var generated = true
export (bool) var can_be_deleted = true
export (bool) var has_apply_button = false
export (bool) var edit_datetime = true
var timespan : TimeSpan setget _set_timespan

onready var datetimecontrol_from := $HBoxContainer/DateTimeControl_From
onready var datetimecontrol_to := $HBoxContainer/DateTimeControl_To
onready var timecontrol_from := $HBoxContainer/TimeControl_From
onready var timecontrol_to := $HBoxContainer/TimeControl_To
onready var button_delete := $HBoxContainer/Button_Delete
onready var button_apply := $HBoxContainer/Button_Apply


func _ready() -> void:
	if generated:
		assert(timespan, "ERROR : timespan cannot be null")
	else:
		timespan = Dates.generate_timespan(0, 8, 0, 0, 21, 0)

	if edit_datetime == false:
		datetimecontrol_from.visible = false
		timecontrol_from.visible = true
		datetimecontrol_to.visible = false
		timecontrol_to.visible = true
	button_delete.visible = can_be_deleted
	button_apply.visible = has_apply_button
	
	datetimecontrol_from.datetime = timespan.from_datetime
	timecontrol_from.datetime = timespan.from_datetime
	datetimecontrol_to.datetime = timespan.to_datetime
	timecontrol_to.datetime = timespan.to_datetime


func _on_ButtonDelete_pressed() -> void:
	emit_signal("entry_deleted", timespan)
	queue_free()


func _on_ButtonApply_pressed() -> void:
	emit_signal("apply_changes", timespan)


func _set_timespan(p_timespan : TimeSpan) -> void:
	timespan = p_timespan


func update_timespan(p_timespan : TimeSpan) -> void:
	datetimecontrol_from.update_time(p_timespan.from_datetime)
	datetimecontrol_to.update_time(p_timespan.to_datetime)

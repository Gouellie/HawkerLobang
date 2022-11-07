extends Control

signal date_changed(datetime)

const MINUTES_INCREMENTS : int = 15

onready var option_day : OptionButton = $HBoxContainer/OptionButton_Day
onready var option_hour : OptionButton = $HBoxContainer/OptionButton_Hour
onready var option_minute : OptionButton = $HBoxContainer/OptionButton_Minute

var datetime : DateTime setget _set_datetime

func _ready() -> void:
	if owner:
		yield(owner, "ready")
	if datetime == null:
		datetime = Dates.get_new_date()
	_add_items()
	_update_selection()


func update_datetime(other_datetime : DateTime) -> void:	
	datetime.update_date(other_datetime)
	_update_selection()


func update_time(other_datetime : DateTime) -> void:	
	datetime.update_time(other_datetime)
	_update_selection()


func _add_items() -> void:
	for day in Dates.WEEKDAYS:
		option_day.add_item(Dates.WEEKDAYS[day])
	for hour in range(24):
		option_hour.add_item("%02d" %hour)
	for minute in range(0, 60, MINUTES_INCREMENTS):
		option_minute.add_item("%02d" %minute)
	

func _on_OptionButton_Day_item_selected(day: int) -> void:
	datetime.day = day
	emit_signal("date_changed", datetime)


func _on_OptionButton_Hour_item_selected(hour: int) -> void:
	datetime.hour = hour
	emit_signal("date_changed", datetime)


func _on_OptionButton_Minute_item_selected(index: int) -> void:
	datetime.minute = _to_minutes_from_index(index)
	emit_signal("date_changed", datetime)


func _to_increments_index(minute : int) -> int:
	if(minute == 0):
		return 0
# warning-ignore:integer_division
	return minute / MINUTES_INCREMENTS


func _to_minutes_from_index(p_index : int) -> int:
	return p_index * MINUTES_INCREMENTS


func _update_selection():
	option_day.select(datetime.day)
	option_hour.select(datetime.hour)
	option_minute.select(_to_increments_index(datetime.minute))


func _set_datetime(p_datetime : DateTime) -> void:
	datetime = p_datetime

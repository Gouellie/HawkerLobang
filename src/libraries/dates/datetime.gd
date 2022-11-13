extends Reference

class_name DateTime

const DAY_KEY = "day"
const HOUR_KEY = "hour"
const MINUTE_KEY = "minute"

var weekly_ticks : int setget ,_get_weekly_ticks

var ticks : int = 0
var day : int = 0
var hour : int = 0
var minute : int = 0


func increment(increment_in_minutes : int = 1) -> void:
	ticks += increment_in_minutes
# warning-ignore:integer_division
	day = (ticks / Dates.MINUTES_PER_DAY) % 7
# warning-ignore:integer_division
	hour = (ticks / Dates.MINUTES_PER_HOUR) % 24
	minute = ticks % 60


func to_string() -> String:
	return "%s %02d:%02d" % [Dates.WEEKDAYS[day], hour, minute]


func _get_weekly_ticks() -> int:
	return Dates.get_ticks(day, hour, minute)


func update_date(other_datetime : DateTime) -> void:
	ticks = other_datetime.ticks
	day = other_datetime.day
	hour = other_datetime.hour
	minute = other_datetime.minute


func update_time(other_datetime : DateTime) -> void:
	hour = other_datetime.hour
	minute = other_datetime.minute
	ticks = Dates.get_ticks(day, hour, minute)
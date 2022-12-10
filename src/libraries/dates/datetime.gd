extends Reference

class_name DateTime

const DAY_KEY = "day"
const HOUR_KEY = "hour"
const MINUTE_KEY = "minute"

var weekly_ticks : int setget ,_get_weekly_ticks

var ticks : int = 0
var week : int = 1
var day : int = 0
var hour : int = 0
var minute : int = 0


func increment(increment_in_minutes : int = 1) -> void:
	ticks += increment_in_minutes
# warning-ignore:integer_division
	week = (ticks / Dates.TICKS_PER_WEEK) + 1
# warning-ignore:integer_division
	day = (ticks / Dates.MINUTES_PER_DAY) % 7
# warning-ignore:integer_division
	hour = (ticks / Dates.MINUTES_PER_HOUR) % 24
	minute = ticks % 60


func _to_string() -> String:
	return to_string()


func to_string() -> String:
	return "Week %d, %s %02d:%02d" % [week, Dates.WEEKDAYS[day], hour, minute]


func to_string_date_only() -> String:
	return "Week %d, %s" % [week, Dates.WEEKDAYS[day]]	


func _get_weekly_ticks() -> int:
	return Dates.get_ticks(1, day, hour, minute)


func update_date(other_datetime : DateTime) -> void:
	week = other_datetime.week
	day = other_datetime.day
	hour = other_datetime.hour
	minute = other_datetime.minute
	ticks = Dates.get_ticks(week, day, hour, minute)


func update_time(other_datetime : DateTime) -> void:
	hour = other_datetime.hour
	minute = other_datetime.minute
	ticks = Dates.get_ticks(week, day, hour, minute)


func from_ticks(p_ticks : int) -> void:
	# setting date back to start
	ticks = 0
	increment(p_ticks)


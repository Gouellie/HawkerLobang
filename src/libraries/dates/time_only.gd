extends Reference

class_name TimeOnly

var ticks : int
var hour : int = 0 setget set_hour,get_hour
var minute : int = 0 setget set_minute,get_minute


func _init(i_hour, i_minute) -> void:
	hour = i_hour
	minute = i_minute
	ticks = Dates.get_ticks(0, hour, minute)


func set_hour(p_hour) -> void:
	hour = p_hour
	ticks = Dates.get_ticks(0, hour, minute)
	

func get_hour() -> int:
	return hour


func set_minute(p_minute) -> void:
	minute = p_minute
	ticks = Dates.get_ticks(0, hour, minute)


func get_minute() -> int:
	return minute

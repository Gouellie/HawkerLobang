extends Reference

class_name TimeSpan

var from_datetime : DateTime
var to_datetime : DateTime


func _init(init_from : DateTime = null, init_to : DateTime = null) -> void:
	from_datetime = init_from
	to_datetime = init_to


func in_span(datetime : DateTime) -> bool:
	var weekly_ticks = datetime.weekly_ticks
	var weekly_ticks_from = from_datetime.weekly_ticks
	var weekly_ticks_to = to_datetime.weekly_ticks
	return weekly_ticks_from < weekly_ticks and weekly_ticks < weekly_ticks_to


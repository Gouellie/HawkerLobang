extends Node2D
class_name BusinessHours

var business_hours := []

func _ready() -> void:
	for day in range(1,6):
		var span = Dates.generate_timespan(day, 8, 0, day, 20, 0)
		business_hours.append(span)


func in_business_hour(date : DateTime) -> bool:
	for timespan in business_hours:
		if timespan.in_span(date):
			return true
	return false


func _copy_business_hours() -> Array:
	var business_hours_copy = []
	for timespan in business_hours:
		business_hours_copy.append(Dates.copy_timespan(timespan))
	return business_hours_copy

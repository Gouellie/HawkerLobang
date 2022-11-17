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


func serialize() -> Array:
	var data = []
	for timespan in business_hours:
		if timespan is TimeSpan:
			data.push_back(
				[timespan.from_datetime.weekly_ticks, timespan.to_datetime.weekly_ticks]
			)
	return data


func deserialize(data : Array) -> void:
	business_hours = []
	for timespan in data:
		if not timespan is Array:
			continue
		if timespan.size() < 2:
			continue 
		var span = Dates.generate_timespan_from_ticks(timespan[0], timespan[1])
		business_hours.append(span)

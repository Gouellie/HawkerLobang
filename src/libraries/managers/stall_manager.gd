extends Reference
class_name StallManager

var _stalls = []

func _init() -> void:
	Global.stall_manager = self
	Log.log_error(Events.connect("open_close_all_stalls", self, "_on_open_close_all_stalls"))


func register_stall(stall : Stall) -> void:
	_stalls.push_back(stall)


func remove_stall(stall : Stall) -> void:
	if _stalls.has(stall):
		_stalls.erase(stall)


func get_operating_stall_count() -> int:
	var count = 0
	for stall in _stalls:
		if stall is Stall and not stall.is_stall_vacant:
			count+=1
	return count



func get_open_stall_count() -> int:
	var count = 0
	for stall in _stalls:
		if stall is Stall and stall.is_open_for_business:
			count+=1
	return count


# todo create new signal that fires ahead of time_elapsed to populate the list of stalls
func get_open_stall() -> Array:
	var open_stalls = []
	for stall in _stalls:
		if stall is Stall and stall.is_open_for_business:
			open_stalls.push_back(stall)
	return open_stalls


func _on_open_close_all_stalls(open : bool) -> void:
	for stall in _stalls:
		stall.set_is_open(open)


func get_today_timespan(day : int) -> TimeSpan:
	var earliest : DateTime = Dates.generate_date(day, 23, 0)
	var latest : DateTime =  Dates.generate_date(day, 0, 0)
	var any_dates : bool = false
	for stall in _stalls:
		if not stall is Stall:
			continue
		if stall.is_stall_vacant:
			continue
		for span in stall.business_hours.business_hours:
			if not span is TimeSpan:
				continue
			if not span.from_datetime.day == day:
				continue
			any_dates = true
			var from : DateTime = span.from_datetime
			var to : DateTime = span.to_datetime
			if Dates.compare_dates(from, earliest) < 0:
				earliest = from
			if Dates.compare_dates(to, latest) > 0:
				latest = to
	if any_dates:
		return Dates.get_timespan(earliest,latest, true)
	return null

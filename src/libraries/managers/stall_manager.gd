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

extends State

var _business_hours : BusinessHours
var _is_in_business_hour : bool


func enter(_msg: Dictionary = {}) -> void:
	owner.label_state.text = "rented"	
	_is_in_business_hour = false
	# warning-ignore:return_value_discarded
	update_business_state(Global.current_datetime, true)


func update_business_state(date_time : DateTime, init : bool) -> bool:
	var previously_in_business_hour = _is_in_business_hour
	_is_in_business_hour = get_is_open_for_business(date_time)
	if not init and previously_in_business_hour == _is_in_business_hour:
		return true # notify child state that there are no changes coming
	var state = "Rented/Open" if _is_in_business_hour else "Rented/Close"
	_state_machine.transition_to(state)
	return false # current state should stop processing


func _get_business_hours() -> BusinessHours:
	if _business_hours == null:
		_business_hours = owner.business_hours
	return _business_hours
	

func get_is_open_for_business(datetime : DateTime)-> bool:
	if owner.is_always_open:
		return true
	if owner.is_manually_closed:
		return false
	
	if _get_business_hours() is BusinessHours:
		return _business_hours.in_business_hour(datetime)
	return false

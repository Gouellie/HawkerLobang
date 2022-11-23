extends State

var _business_hours : BusinessHours

var is_in_business_hour : bool

var _owner

func _ready() -> void:
	_owner = owner


func enter(_msg: Dictionary = {}) -> void:
	_set_business_state(Global.current_datetime)
	

func on_time_ellapsed(date_time : DateTime) -> void:
	_set_business_state(date_time)
	

func _set_business_state(date_time : DateTime) -> void:
	is_in_business_hour = _check_if_operational(date_time)
	_owner.set_stall_is_open(is_in_business_hour)


func select(_event: InputEventMouse) -> void:
	pass


func _get_business_hours() -> BusinessHours:
	if _business_hours == null:
		_business_hours = _owner.business_hours
	return _business_hours
	

func _check_if_operational(datetime : DateTime)-> bool:
	if _get_business_hours() is BusinessHours:
		return _business_hours.in_business_hour(datetime)
	return false

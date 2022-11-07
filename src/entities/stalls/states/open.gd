extends State

onready var business_hours : Node2D = $BusinessHours

var is_in_business_hour : bool

func enter(_msg: Dictionary = {}) -> void:
	owner.stall_shape.color = Color.olivedrab
	

func on_time_ellapsed(dateTime : DateTime) -> void:
	is_in_business_hour = check_if_operational(dateTime)
	owner.stall_shape.color = Color.olivedrab if is_in_business_hour else Color.sandybrown


func select(_event: InputEventMouse) -> void:
	# TODO open control panel
	business_hours.edit_business_hours()


func check_if_operational(datetime : DateTime)-> bool:
# warning-ignore:unsafe_method_access
	return business_hours.in_business_hour(datetime)

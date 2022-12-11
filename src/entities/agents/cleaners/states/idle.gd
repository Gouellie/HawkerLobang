extends State


func enter(_msg: Dictionary = {}) -> void:
	owner.skin.visible = false
	pass


func exit() -> void:
	pass


func on_time_ellapsed(_dateTime : DateTime) -> void:
	pass


func start_shift() -> void:
	_state_machine.transition_to("Moving/Start_Shift")

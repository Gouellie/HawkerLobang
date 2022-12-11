extends State


func enter(_msg: Dictionary = {}) -> void:
	_parent.set_navigation_speed(Global.current_speed)
	if owner.is_group_leader:
		_state_machine.transition_to("Moving/ChopeTable")
	else:
		_state_machine.transition_to("Moving/Browsing")


func exit() -> void:
	pass

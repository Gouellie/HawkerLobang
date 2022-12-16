extends State


func enter(_msg: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass


func set_navigation_speed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func set_navigation_position(pos : Vector2) -> void:
	_parent.set_navigation_position(pos)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")

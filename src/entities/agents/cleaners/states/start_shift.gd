extends State


func enter(_msg: Dictionary = {}) -> void:
	var entrance = Global.entrance_manager.get_entrance()
	owner.global_position = entrance
	owner.skin.visible = true
	_parent.set_navigation_speed(Global.current_speed)


func exit() -> void:
	pass


func on_speed_changed(speed : int) -> void:
	_parent.set_navigation_speed(speed)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func end_shift() -> void:
	_state_machine.transition_to("Moving/End_Shift")
